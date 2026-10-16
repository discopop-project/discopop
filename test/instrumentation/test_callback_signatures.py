"""The callbacks the pass declares have to match the functions the runtime library defines.

The pass declares each ``__dp_*`` callback in the module it instruments, the runtime library defines
it as an ``extern "C"`` function (``profiler/rtlib/injected_functions/*.hpp``). Nothing connects the
two: the linker matches the names only, so a parameter that is narrower in one of them goes unnoticed
and the callee reads a register whose upper half the caller never set. This test compares the
declarations in the instrumented IR with the prototypes in the headers.
"""

import re
from pathlib import Path
from typing import Dict, List

from .utilities import InstrumentationTestCase

HEADERS = Path(__file__).resolve().parents[2] / "profiler" / "rtlib" / "injected_functions"

# the C++ types of the prototypes and the IR types they correspond to
IR_TYPES = {
    "LID": "i64",
    "ADDR": "i64",
    "int64_t": "i64",
    "int32_t": "i32",
    "uint32_t": "i32",
    "int": "i32",
    "char *": "ptr",
    "const char *": "ptr",
}


def runtime_prototypes() -> Dict[str, List[str]]:
    """The parameter types (as IR types) of every callback in the runtime headers."""
    prototypes: Dict[str, List[str]] = {}
    for header in sorted(HEADERS.glob("*.hpp")):
        skipping = False
        for line in header.read_text().splitlines():
            # the variant for -DSKIP_DUP_INSTR, which the pass declares only when built with it too
            if line.startswith("#ifdef SKIP_DUP_INSTR"):
                skipping = True
            elif line.startswith("#else") or line.startswith("#endif"):
                skipping = False
            if skipping:
                continue
            match = re.match(r"\s*(?:void|uint32_t)\s+(__dp_\w+)\((.*)\);", line)
            if match is None:
                continue
            parameters = [p.strip() for p in match.group(2).split(",") if p.strip()]
            # drop the parameter names: "LID lid" -> "LID", "char* var" / "char *var" -> "char *"
            types = [re.sub(r"\s*\*\s*", " *", re.sub(r"\s*\w+$", "", p)).strip() for p in parameters]
            prototypes[match.group(1)] = [IR_TYPES[t] for t in types]
    return prototypes


class TestCallbackSignatures(InstrumentationTestCase):
    # touches every kind of callback the pass inserts
    SOURCE = """
        #include <cstdlib>

        int helper(int x) {
          return x + 1;
        }

        int main() {
          int local[4];
          int *heap = (int *)malloc(4 * sizeof(int));
          int *zeroed = (int *)calloc(4, sizeof(int));
          heap = (int *)realloc(heap, 8 * sizeof(int));
          int *created = new int[4];
          for (int i = 0; i < 4; ++i) {
            local[i] = helper(i);
            heap[i] = local[i];
            created[i] = heap[i] + zeroed[i];
          }
          int result = created[3];
          delete[] created;
          free(zeroed);
          free(heap);
          return result;
        }
        """

    def declarations(self) -> Dict[str, List[str]]:
        """Parameter types of every __dp_ function declared in the instrumented module."""
        declared: Dict[str, List[str]] = {}
        for match in re.finditer(r"^declare\s[^@\n]*@(__dp_\w+)\((.*?)\)", self.program.ir, re.MULTILINE):
            parameters = [p.strip() for p in match.group(2).split(",") if p.strip()]
            declared[match.group(1)] = [p.split()[0] for p in parameters]
        return declared

    def test_every_declared_callback_exists_in_the_runtime(self) -> None:
        prototypes = runtime_prototypes()
        for name in self.declarations():
            self.assertIn(name, prototypes, f"{name} is declared by the pass but not by the runtime headers")

    def test_declared_parameter_types_match_the_runtime(self) -> None:
        prototypes = runtime_prototypes()
        declared = self.declarations()
        # the program must actually reach the callbacks this test is about
        for name in ("__dp_read", "__dp_write", "__dp_alloca", "__dp_new", "__dp_delete"):
            self.assertIn(name, declared)
        for name, parameters in declared.items():
            self.assertEqual(prototypes[name], parameters, f"the declaration of {name} differs from the runtime's")
