# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
from typing import Dict, List, Tuple, Union

import numpy as np
from scipy.interpolate import LinearNDInterpolator  # type: ignore

from .Microbench import (
    Microbench,
    MicrobenchType,
    MicrobenchDimension,
    MicrobenchCoordinate,
)
from .PureDataMicrobench import PureDataMicrobench


# This class uses Delaunay Interpolation to create a microbench model from measurements. No extrapolation is possible
class DelaunayInterpolatedMicrobench(Microbench):
    data: PureDataMicrobench

    __isInterpolated = False

    def __init__(
        self,
        data: Union[
            PureDataMicrobench,
            Dict[
                MicrobenchType,
                Dict[MicrobenchDimension, Dict[MicrobenchCoordinate, List[float]]],
            ],
        ],
        removeOutliers: bool = False,
    ):
        if isinstance(data, PureDataMicrobench):
            self.data = data
        else:
            self.data = PureDataMicrobench(data)

        if removeOutliers:
            self.data.removeOutliers()

    def removeZeroParameters(self):
        self.data.removeZeroParameters()
        self.__isInterpolated = False

    def clampValues(self, min: float = 0.0, max: float = float("inf")):
        self.data.clampValues()
        self.__isInterpolated = False

    def removeOutliers(self):
        self.data.removeOutliers()
        self.__isInterpolated = False

    def useMedian(self):
        self.data.useMedian()
        self.__isInterpolated = False

    def useMean(self):
        self.data.useMean()
        self.__isInterpolated = False

    def __getTuples(self, benchType: MicrobenchType, benchDim: MicrobenchDimension):
        tuples: List[Tuple[int, Union[int, float], int, float]] = []
        for benchCoord, values in self.data[benchType][benchDim].items():
            tuples.append((*benchCoord, np.median(values).item()))
        return tuples

    def __interpolate(self):
        def __createInterpolator(tuples):
            coords = []
            values = []
            for t in tuples:
                coords.append(t[:3])
                values.append(t[3])
            return LinearNDInterpolator(coords, values, fill_value=float("nan"))

        self.interpolator = {
            type: {dim: __createInterpolator(self.__getTuples(type, dim)) for dim in dimMap.keys()}
            for type, dimMap in self.data.getMeasurements().items()
        }

    def getMeasurements(self):
        return self.data.getMeasurements()

    def toJSON(self):
        return self.data.toJSON()

    def evaluateInterpolation(
        self,
        benchType: MicrobenchType,
        benchDim: MicrobenchDimension,
        benchCoord: Union[MicrobenchCoordinate, Tuple[int, float, float]],
    ):
        if not self.__isInterpolated:
            self.__interpolate()
            self.__isInterpolated = True
        return self.interpolator[benchType][benchDim](benchCoord) / 1000000.0  # convert microseconds to seconds
