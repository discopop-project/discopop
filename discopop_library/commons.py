import os


def get_path(base_path: str, file_name: str) -> str:
    """Combines path and filename if it is not absolute
    :param base_path: path
    :param file_name: file name
    :return: path to file
    """
    return file_name if os.path.isabs(file_name) else os.path.join(base_path, file_name)
