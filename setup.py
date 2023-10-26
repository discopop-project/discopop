# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import sys
from pathlib import Path

from setuptools import setup, find_packages  # type:ignore

from discopop_library.global_data.version.utils import get_version

os.chdir(Path(__file__).parent)

if sys.version_info < (3, 6):
    raise SystemExit("Discopop explorer requires Python >= 3.6.")

setup(
    name="discopop",
    version=get_version(),
    packages=find_packages(),
    url="https://www.discopop.tu-darmstadt.de/",
    author="TU Darmstadt and Iowa State University",
    author_email="discopop@lists.parallel.informatik.tu-darmstadt.de",
    description="DiscoPoP is a tool that helps software developers parallelize their "
    "programs with threads. It discovers potential parallelism in a "
    "sequential program and makes recommendations on how to exploit it.",
    # long_description=open(SRC / "README.md").read(),
    long_description_content_type="text/markdown",
    install_requires=[
        "contextlib2>=0.5.5",
        "docopt>=0.6.2",
        "extrap",
        "jsonpickle",
        "jsons",
        "lxml>=4.3.3",
        "matplotlib",
        "networkx",
        "numpy>=1.16.3",
        "pluginbase>=1.0.0",
        "pstats2",
        "schema>=0.7.0",
        "sympy",
        "sympy_plot_backends",
        "alive_progress",
    ],
    extras_require={
        "dev": ["mypy", "black", "data-science-types", "pre-commit"],
        "ci": ["mypy", "black", "data-science-types"],
    },
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "discopop_explorer=discopop_explorer.__main__:main",
            "discopop_profiler=discopop_profiler.__main__:main",
            "discopop_wizard=discopop_wizard.__main__:main",
            "discopop_code_generator=discopop_library.CodeGenerator.__main__:main",
            "discopop_optimizer=discopop_library.discopop_optimizer.__main__:main",
            "discopop_patch_generator=discopop_library.PatchGenerator.__main__:main",
            "discopop_patch_applicator=discopop_library.PatchApplicator.__main__:main",
        ]
    },
    zip_safe=True,
    classifiers=[
        "Development Status :: 4 - Beta",
        "Environment :: Console",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Topic :: Software Development",
    ],
    license_files=["LICENSE"],
    include_package_data=True,
)
