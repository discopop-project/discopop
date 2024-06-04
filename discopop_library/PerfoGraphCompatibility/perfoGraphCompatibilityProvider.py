import logging
from discopop_library.PerfoGraphCompatibility import PerfoGraphCompatibilityArguments


def run(arguments: PerfoGraphCompatibilityArguments):
    logger = logging.getLogger("PerfoGraphCompatProvider")
    
    logger.info("starting...")
