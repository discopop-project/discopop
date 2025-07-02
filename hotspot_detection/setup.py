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

os.chdir(Path(__file__).parent)

if sys.version_info < (3, 6):
    raise SystemExit("Hotspot Analyzer requires Python >= 3.6.")

setup(
    name="hotspot analyzer",
    version="0.1",
    packages=find_packages(),
    url="https://www.discopop.tu-darmstadt.de/",
    author="TU Darmstadt and Iowa State University",
    author_email="discopop@lists.parallel.informatik.tu-darmstadt.de",
    description="The Hotspot Analyzer is a simple tool that allows "
    "developers to identify hotspots in their code. ",
    # long_description=open(SRC / "README.md").read(),
    long_description_content_type="text/markdown",
    install_requires=[
	"numpy",
    ],
    extras_require={
    },
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "hotspot_analyzer=hotspot_analyzer.__main__:main",
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
