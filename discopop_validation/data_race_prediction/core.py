from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.target_code_sections.extraction import \
    identify_target_sections_from_suggestion
from discopop_validation.data_race_prediction.behavior_modeller.core import extract_behavior_model


def validate_suggestion(run_configuration: Configuration, pet: PETGraphX, suggestion_type, suggestion, parallelization_suggestions):
    if run_configuration.verbose_mode:
        print("identify target code sections...")
    target_code_sections = identify_target_sections_from_suggestion(suggestion_type, suggestion)

    if run_configuration.verbose_mode:
        print("extract behavior model...")
    for tcs in target_code_sections:
        behavior_models = extract_behavior_model(run_configuration, pet, tcs, parallelization_suggestions)
        for model in behavior_models:
            for op in model:
                print(op)
