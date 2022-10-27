import os
from os.path import dirname

from discopop_wizard.screens.main import show_main_screen, initialize_screen


# todo add command line option to list available run configurations
# todo add command line option to execute run configuration (by name)

def main():
    print("starting DiscoPoP Wizard...\n")
    discopop_dir = dirname(dirname(os.path.abspath(__file__)))
    config_dir = os.path.join(discopop_dir, ".config")

    # check if config exists, if not, initialize config folder and files
    if not os.path.exists(config_dir):
        os.mkdir(config_dir)
        # create run_configurations.txt
        with open(os.path.join(config_dir, "run_configurations.txt"), "w+"):
            pass

    initialize_screen(config_dir)
    print()