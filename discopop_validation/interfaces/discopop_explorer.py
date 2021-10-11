from typing import Optional, List, Tuple

try:
    from discopop_explorer import run, DetectionResult, PETGraphX, utils
except ModuleNotFoundError:
    from discopop.discopop_explorer import run
    from discopop.discopop_explorer import DetectionResult
    from discopop.discopop_explorer import utils


def get_parallelization_suggestions(cu_xml: str, dep_file: str, loop_counter_file: str, reduction_file: str,
                                    plugins: List[str], file_mapping: Optional[str] = None,
                                    cu_inst_result_file: Optional[str] = None, llvm_cxxfilt_path: Optional[str] = None,
                                    discopop_build_path: Optional[str] = None, enable_task_pattern: bool = False)\
        -> Tuple[DetectionResult, PETGraphX] :
    """wrapper to execute discopop_explorer and obtain a list of parallelization suggestions for further processing"""
    res, pet = run(cu_xml, dep_file, loop_counter_file, reduction_file, plugins, file_mapping, cu_inst_result_file,
              llvm_cxxfilt_path, discopop_build_path, enable_task_pattern)
    return res, pet


def is_loop_index(pet: PETGraphX, root_loop, var_name: str):
    return utils.is_loop_index2(pet, root_loop, var_name)