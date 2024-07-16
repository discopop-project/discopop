from argparse import ArgumentParser
from discopop_library.EmpiricalAutotuning.ArgumentClasses import AutotunerArguments
from discopop_library.GlobalLogger.setup import setup_logger
from discopop_library.EmpiricalAutotuning.Autotuner import run


def parse_args() -> AutotunerArguments:
    """Parse the arguments passed to the discopop autotuner"""
    parser = ArgumentParser(description="DiscoPoP Autotuner")

    # fmt: off
    
    parser.add_argument("--log", type=str, default="WARNING", help="Specify log level: DEBUG, INFO, WARNING, ERROR, CRITICAL")
    parser.add_argument("--write-log", action="store_true", help="Create Logfile.")
    # fmt: on

    arguments = parser.parse_args()

    return AutotunerArguments(
        log_level=arguments.log.upper(),
        write_log=arguments.write_log,
    )


def main() -> None:
    arguments = parse_args()
    setup_logger(arguments)
    run(arguments)


if __name__ == "__main__":
    main()
