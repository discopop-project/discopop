import subprocess
from typing import Dict


def run_cmd(cmd: str, cwd: str, env: Dict[str, str]) -> None:
    subprocess.run(
        cmd,
        cwd=cwd,
        executable="/bin/bash",
        shell=True,
        env=env,
        #        stdout=subprocess.DEVNULL,
        #        stderr=subprocess.DEVNULL,
    )
