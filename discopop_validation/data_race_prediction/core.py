import time
from random import randrange
from typing import List

from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.data_race_prediction.behavior_modeller.classes.BehaviorModel import BehaviorModel
from discopop_validation.data_race_prediction.scheduler.classes.Schedule import Schedule
from discopop_validation.data_race_prediction.scheduler.core.scheduler import \
    create_scheduling_graph_from_behavior_models, __convert_operation_list_to_schedule_element_list
from discopop_validation.data_race_prediction.scheduler.utils.schedules import get_schedules
from discopop_validation.data_race_prediction.target_code_sections.extraction import \
    identify_target_sections_from_suggestion
from discopop_validation.data_race_prediction.behavior_modeller.core import extract_behavior_models
from discopop_validation.data_race_prediction.vc_data_race_detector.classes.DataRace import DataRace
from discopop_validation.data_race_prediction.vc_data_race_detector.core import check_scheduling_graph
from copy import deepcopy

from discopop_validation.data_race_prediction.vc_data_race_detector.data_race_detector import check_schedule


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

        # simulation for 2 threads
        behavior_model_list = [behavior_models[0], deepcopy(behavior_models[0])]

        if run_configuration.validation_time_limit == "None":
            # no time limit set, execute full validation
            data_races = __full_validation(run_configuration, behavior_model_list)
        else:
            # time limit set, execute bound validation
            run_configuration.validation_time_limit = int(run_configuration.validation_time_limit)
            data_races = __bound_validation(run_configuration, behavior_model_list)

        for dr in data_races:
            print()
            print(dr)


def __bound_validation(run_configuration: Configuration, behavior_model_list: List[BehaviorModel]) -> List[DataRace]:
    data_races = []
    # convert operations to schedule elements
    for thread_idx, behavior_model in enumerate(behavior_model_list):
        behavior_model_list[thread_idx].scheduleElements = __convert_operation_list_to_schedule_element_list(behavior_model.operations, thread_idx)

    time_start = time.time()
    #todo parallelize
    count = 0
    while(time.time() - time_start < run_configuration.validation_time_limit):
        # build a random schedule
        schedule = Schedule()
        progress = [0] * len(behavior_model_list)
        while(sum(progress) < sum([len(elem.scheduleElements) for elem in behavior_model_list])):
            thread_id = randrange(len(behavior_model_list))
            if progress[thread_id] >= len(behavior_model_list[thread_id].scheduleElements):
                continue
            schedule.add_element(behavior_model_list[thread_id].scheduleElements[progress[thread_id]])
            progress[thread_id] += 1
        count += 1
        #validate the schedule

    print(count)


    return data_races


def __full_validation(run_configuration: Configuration, behavior_model_list: List[BehaviorModel]) -> List[DataRace]:
    if run_configuration.verbose_mode:
        print("creating scheduling graph...")
    # dimensions can be used to determine the depth of the graph and thus the cutoff-point for task creation
    scheduling_graph, dimensions = create_scheduling_graph_from_behavior_models(behavior_model_list)

    data_races = []
    # todo might be removed or added as a parameter
    enable_recursive_checking = True
    if enable_recursive_checking:
        # check scheduling graph recursively for data races
        if run_configuration.verbose_mode:
            print("check scheduling graph for data races...")
        # todo task creation
        data_races = check_scheduling_graph(scheduling_graph, dimensions)
    else:
        # create schedules and validate the afterwards
        if run_configuration.verbose_mode:
            print("creating schedules...")
        schedules = get_schedules(scheduling_graph.graph, scheduling_graph.root_node_identifier)
        if run_configuration.verbose_mode:
            print("validating schedules...")
        data_races = []
        for schedule in schedules:
            data_races += check_schedule(schedule)
    return data_races