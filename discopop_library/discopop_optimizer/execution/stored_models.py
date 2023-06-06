import os
from pathlib import Path
from typing import Dict, List


def execute_stored_models(arguments: Dict):
    """Collects and executes all models stored in the current project path"""
    print("Executing stored models...")

    # collect models from path
    collected_model_paths: List[str] = []

    code_export_path = os.path.join(arguments["--project-folder"], ".discopop_optimizer", "code_exports")



