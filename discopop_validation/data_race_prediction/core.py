from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.target_code_sections.extraction import \
    identify_target_sections_from_suggestion


def validate_suggestion(run_configuration: Configuration, pet: PETGraphX, suggestion_type, suggestion):
    if run_configuration.verbose_mode:
        print("identify target code sections")
    target_code_sections = identify_target_sections_from_suggestion(suggestion_type, suggestion)
    #if run_configuration.verbose_mode:
    #    print("creating BB Graph...")
    #bb_graph = execute_bb_graph_extraction(target_code_sections, file_mapping, ll_file, arguments["--dp-build-path"])
    #insert_critical_sections(bb_graph, parallelization_suggestions)