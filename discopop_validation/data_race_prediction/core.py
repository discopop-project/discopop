from typing import List

from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.core.scheduler import \
    create_scheduling_graph_from_behavior_models
from discopop_validation.data_race_prediction.target_code_sections.extraction import \
    identify_target_sections_from_suggestion
from discopop_validation.data_race_prediction.behavior_modeller.core import extract_behavior_models
from discopop_validation.data_race_prediction.vc_data_race_detector.core import check_scheduling_graph
from copy import deepcopy

def validate_suggestion(run_configuration: Configuration, pet: PETGraphX, suggestion_type, suggestion, parallelization_suggestions):
    if run_configuration.verbose_mode:
        print("identify target code sections...")
    target_code_sections = identify_target_sections_from_suggestion(suggestion_type, suggestion)

    if run_configuration.verbose_mode:
        print("extract behavior model...")
    for tcs in target_code_sections:
        behavior_models: List[BehaviorModel] = extract_behavior_models(run_configuration, pet, tcs, parallelization_suggestions)
        if run_configuration.verbose_mode:
            for model in behavior_models:
                print("Behavior Model:")
                for op in model.operations:
                    print("\t", op)

        if run_configuration.verbose_mode:
            print("creating scheduling graph...")
        # simulation for 2 threads
        behavior_model_list = [behavior_models[0], deepcopy(behavior_models[0])]
        # dimensions can be used to determine the depth of the graph and thus the cutoff-point for task creation

        scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_model_list)


        if run_configuration.verbose_mode:
            print("check scheduling graph for data races...")
        # todo task creation
        data_races = check_scheduling_graph(scheduling_graph, dimensions)
        for dr in data_races:
            print()
            print(dr)