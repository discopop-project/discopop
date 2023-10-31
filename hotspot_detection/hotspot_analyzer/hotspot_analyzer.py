import os.path
import numpy as np
import json
import sys
from typing import List
from enum import Enum
from dataclasses import dataclass

inf = float("inf")


@dataclass
class HotspotAnalyzerArguments(object):
    """Container Class for the arguments passed to the hotspot analyzer"""

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        """Validate the arguments passed to the discopop_explorer, e.g check if given files exist"""
        validation_failure = False

        if validation_failure:
            print("Exiting...")
            sys.exit()


class cs:
    def __init__(self, csid):
        self.csid = csid  # note: csid is a unique identifier
        self.typ = False  # function is false, loop is true
        self.fid = 0  # file id
        self.lineNum = 0  # line number
        self.name = ""  # only for functions: name of function
        self.runtimes = []  # runtimes
        self.level = 0
        self.hot = True
        self.hotness = "MAYBE"  # possible: YES, NO, MAYBE

    delta = -1.0
    avr = 0.0
    sum = -1
    minVal = inf
    maxVal = 0.0
    ratio = 0.0
    topAvr = False
    topRatio = False

    def toJSON(self):
        return json.dumps(self.__dict__, indent=4)

    def addData(self, runtime):
        self.runtimes.append(runtime)

    def addInfo(self, tp, linN, filN, namN):
        self.typ = tp
        self.lineNum = linN
        self.fid = filN
        self.name = namN

    def updateLevel(self, lvl):
        self.level = lvl

    def calMin(self):
        for x in self.runtimes:
            self.minVal = min(x, self.minVal)

    def roundMin(self):
        if self.minVal == 0:
            self.minVal = 0.000001

    def calMax(self):
        for x in self.runtimes:
            self.maxVal = max(x, self.maxVal)

    def calDelta(self):
        self.delta = self.maxVal - self.minVal

    def calRatio(self):
        self.ratio = 1 / ((self.minVal / self.maxVal) + 1)

    def calAvr(self):
        tempSum = 0
        for i in self.runtimes:
            tempSum += i
        self.avr = tempSum / len(self.runtimes)
        self.sum = tempSum

    def isHot(self, bl):
        self.hot = bl

    def isTopAvr(self, bl):
        self.topAvr = bl

    def isTopRatio(self, bl):
        self.topRatio = bl

    def getHotness(self):
        if self.topAvr == True and self.topRatio == True:
            return "YES"
        if self.topAvr != self.topRatio:
            return "MAYBE"
        return "NO"


def __print_cs_list(list: List[cs]):
    for x in list:
        print(
            "##cs lists:",
            str(x.typ).ljust(6),
            str(x.csid).ljust(2),
            str(x.fid).ljust(2),
            "{:10.7f}".format(x.runtimes[0]),
            "avr:" + "{:10.7f}".format(x.avr),
            "sum:" + "{:10.7f}".format(x.sum),
            f"ratio:{x.ratio} min:{x.minVal} max:{x.maxVal} topAvr:{x.topAvr} topRatio:{x.topRatio}",
        )
    print(len(list))


def run(arguments: HotspotAnalyzerArguments):
    ## TO BE USED FROM WITHIN THE .discopop directory!
    discopop_dir = os.getcwd()
    print("DiscoPoP Dir: ", discopop_dir)
    # enter hotspot_detection/private folder
    hotspot_detection_dir = os.path.join(discopop_dir, "hotspot_detection")
    hotspot_detection_private_dir = os.path.join(hotspot_detection_dir, "private")
    if not os.path.exists(hotspot_detection_dir):
        raise FileNotFoundError("Static analysis and profiling results not found: Please execute the static analysis and profiling!" )
    if not os.path.exists(hotspot_detection_private_dir):
        raise FileNotFoundError("Static analysis and profiling results not found: Please execute the static analysis and profiling!" )
    os.chdir(hotspot_detection_private_dir)



    ## CS LIST
    # TODO turn this into a Dict
    cslist: List[cs] = []

    def findCs(iid):
        for x in cslist:
            if x.csid == iid:
                return x
        return False

    def getHots(bl):
        Hots = []
        for x in cslist:
            if x.hot == bl:
                Hots.append(x)
        return Hots

    def getSum(lst):
        hotSum = 0
        for i in lst:
            hotSum += i.avr
        return hotSum

    ## READ FILES
    print("Reading hotspot results... ", end="")
    idfile = open("hotspot_result_0.txt", "r")
    for line in idfile:
        c = cs(int(line.split()[0]))
        cslist.append(c)
    idfile.close()

    i = 0
    resultNum = 0
    minData = inf
    maxData = 0
    while True:
        fileName = f"hotspot_result_{i}.txt"
        i += 1
        if os.path.exists(fileName):
            # print("a file")
            pass
        else:
            # print("no file")
            break
        resultNum += 1
        dataFile = open(fileName, "r")
        for line in dataFile:
            temp = []
            for word in line.split():
                temp.append(word)
            tempCs = findCs(int(temp[0]))
            if tempCs:
                tempCs.addData(float(temp[1]))
        dataFile.close()

    print("Done.")

    print("Reading cs_id.txt ... ", end="")
    csfile = open("cs_id.txt", "r")
    for line in csfile:
        temp = []
        for word in line.split():
            temp.append(word)

        tempCs = findCs(int(temp[0]))
        if tempCs:
            if temp[1] == "func":
                tempCs.addInfo(False, int(temp[2]), int(temp[3]), "func")
            if temp[1] == "loop":
                tempCs.addInfo(True, int(temp[2]), int(temp[3]), "loop")
    csfile.close()
    print("Done.")

    ## CALCULATE
    vMAX = 0
    vMIN = inf
    dMAX = 0
    dMIN = inf
    deltaData = maxData - minData
    ratioData = maxData / minData

    __print_cs_list(cslist)

    NZcslist: List[cs] = []

    print("Calculate Averages ... ", end="")
    for j in cslist:
        j.calAvr()
    print("Done.")

    for m in cslist:
        if m.sum > 0:
            NZcslist.append(m)

    print("Calculate Min,Max,Avg ... ", end="")
    for j in NZcslist:
        j.calMin()
        j.calMax()
        j.calAvr()
    print("Done.")

    print("Calculate Delta and Ratio ... ", end="")
    for j in NZcslist:
        j.roundMin()
        j.calDelta()
        j.calRatio()
    print("Done.")

    tempmax = 0
    maxCS = 0

    for x in NZcslist:
        if x.maxVal >= tempmax:
            tempmax = x.maxVal
            maxCS = x

    print("max cs: ", maxCS.csid, " ", maxCS.maxVal)

    # sorting cs list based on avr and ratio
    print("Sort CS lists ... ", end="")
    sortedCsAvr = NZcslist.copy()
    sortedCsAvr.sort(key=lambda x: x.avr, reverse=True)

    sortedCsRatio = NZcslist.copy()
    sortedCsRatio.sort(key=lambda x: x.ratio, reverse=True)
    print("Done.")

    # detecting hotspots of each list by mean or median
    print("Detect hotspots ... ", end="")
    mean = True
    if mean:
        avrMiddle = np.mean([x.avr for x in NZcslist])
        ratioMiddle = np.mean([x.ratio for x in NZcslist])
    else:
        avrMiddle = np.median([x.avr for x in NZcslist])
        ratioMiddle = np.median([x.ratio for x in NZcslist])

    for x in NZcslist:
        if x.avr >= avrMiddle:
            x.isTopAvr(True)

    for x in NZcslist:
        if x.ratio >= ratioMiddle:
            x.isTopRatio(True)
    print("Done")

    # print
    __print_cs_list(NZcslist)
    print(ratioMiddle)

    ## WRITE OUT RESULTS
    print("Output results ... ", end="")

    with open("hotspot_result.txt", "w") as f:
        for x in NZcslist:
            f.write(f"{x.csid} {x.ratio} {x.avr} {x.minVal} {x.maxVal} {x.getHotness()}\n")

    # categorize Hotspots based on my definition
    f = open("Hotspots.txt", "w")
    f.write("Is this code region a hotspot? \n")
    counterY = 0
    counterM = 0
    counterN = 0
    for x in NZcslist:
        if x.topAvr == True and x.topRatio == True:
            counterY += 1
            yesNoMaybe = " is YES"
            x.hotness = "YES"
        if x.topAvr != x.topRatio:
            counterM += 1
            yesNoMaybe = " is MAYBE"
            x.hotness = "MAYBE"
        if x.topAvr == False and x.topRatio == False:
            counterN += 1
            yesNoMaybe = " is NO"
            x.hotness = "NO"
        f.write(str(x.csid) + " " + str(x.name) + " at " + str(x.fid) + ":" + str(x.lineNum) + yesNoMaybe + "\n")
        # f.write(" "+ str(x.topAvr)+" "+ str(x.topRatio)+"\n")
    f.write("Number of YES code regions: " + str(counterY) + " \n")
    f.write("Number of MAYBE code regions: " + str(counterM) + " \n")
    f.write("Number of NO code regions: " + str(counterN) + " \n")
    f.write("Number of Non-zero code regions: " + str(counterN + counterM + counterY) + " \n")
    f.close()


    # export results to Hotspots.json and store in "public" folder
    with open(os.path.join(hotspot_detection_dir, "Hotspots.json"), "w+") as outfile:
        outfile.write("{\"code_regions\": [")
        for id, x in enumerate(NZcslist):
            outfile.write(x.toJSON())
            if id != len(NZcslist) - 1:
                outfile.write(",\n")
            else:
                # last element of the list
                outfile.write("\n")
        outfile.write("]\n")
        outfile.write("}\n")

    print("Done")