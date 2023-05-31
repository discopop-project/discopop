import os.path
from typing import List

inf = float('inf')

class cs:
	def __init__(self, csid):
		self.csid = csid # note: csid is a unique identifier
		self.typ = False # function is false, loop is true
		self.fid = 0 # file id
		self.lineNum = 0 # line number
		self.name = "" # only for functions: name of function
		self.result = [] # runtimes
		self.level = 0
		self.hot = True

	delta = -1.0
	avr = 0.0
	summ = -1
	minVal = inf
	maxVal = 0.0
	ratio = 0.0
	topAvr = False
	topRatio = False

	def addData(self,runtime):
		self.result.append(runtime)

	def addInfo(self, tp, linN, filN, namN):
		self.typ = tp
		self.lineNum = linN
		self.fid = filN
		self.name = namN

	def updateLevel(self,lvl):
		self.level = lvl 

	def calMin(self):
		for x in self.result:
			self.minVal = min(x,self.minVal)

	def roundMin(self):
		if self.minVal == 0:
			self.minVal = 0.000001

	def calMax(self):
		for x in self.result:
			self.maxVal = max(x,self.maxVal) 

	def calDelta(self):
		self.delta = self.maxVal - self.minVal

	def calRatio(self):
		self.ratio = 1 / ((self.minVal / self.maxVal)+1) 

	def calAvr(self):
		tempSum = 0
		for i in self.result:
			tempSum += i
		self.avr = tempSum / len(self.result)
		self.summ = tempSum

	def isHot(self,bl):
		self.hot = bl

	def isTopAvr(self,bl):
		self.topAvr = bl

	def isTopRatio(self,bl):
		self.topRatio = bl


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
		if x.hot == bl :
			Hots.append(x) 
	return Hots

def getSum(lst):
	hotSum = 0
	for i in lst:
		hotSum += i.avr 
	return hotSum


## READ FILES
idfile = open('hotspot_result_1.txt','r') 
for line in idfile:
	c = cs(int(line.split()[0]))
	cslist.append(c)
idfile.close()

i = 0 
resultNum = 0
minData = inf
maxData = 0
while True:
	i += 1
	fileName = "hotspot_result_" + str(i) + ".txt"
	if os.path.exists(fileName):
		#print("a file")
		pass 
	else:
		#print("no file")
		break
	resultNum += 1
	dataFile = open(fileName, 'r')
	for line in dataFile:
		temp = []
		for word in line.split():
			temp.append(word)
		tempCs = findCs(int(temp[0]))
		tempCs.addData(float(temp[1]))
	dataFile.close()


csfile = open('cs_id.txt','r') 
for line in csfile:
	temp = []
	for word in line.split():
		temp.append(word)
	
	tempCs = findCs(int(temp[0]))
	if temp[1] == 'func':
		tempCs.addInfo(False, int(temp[2]), int(temp[3]), 'func')
	if temp[1] == 'loop':
		tempCs.addInfo(True, int(temp[2]), int(temp[3]), 'loop')
csfile.close()



## CALCULATE
vMAX = 0
vMIN = inf
dMAX = 0
dMIN = inf
deltaData = maxData - minData
ratioData = maxData / minData

for x in cslist:
	print("#cs lists: ", x.typ, " ", x.csid, " ", x.fid, " " , x.result ,  " avr: ", x.avr, " sum:", x.summ, " ratio: ", x.ratio, " min: ", x.minVal, " max: ", x.maxVal, " topAvr: ", x.topAvr, " topRatio: " , x.topRatio, "\n")
print(len(cslist))

NZcslist = []

for j in cslist:
	j.calAvr()

for m in cslist:
	if m.summ > 0:
		NZcslist.append(m)

for j in NZcslist:
	j.calMin()
	j.calMax()
	j.calAvr()

for j in NZcslist:
	j.roundMin()
	j.calDelta()
	j.calRatio()

tempmax = 0

for x in NZcslist:
	if x.maxVal >= tempmax:
		tempmax = x.maxVal
		maxCS = x

print("max cs: ", maxCS.csid, " ", maxCS.maxVal)

#sorting cs list based on avr and ratio

sortedCsAvr = NZcslist.copy() 
sortedCsAvr.sort(key=lambda x: x.avr, reverse=True)


sortedCsRatio = NZcslist.copy() 
sortedCsRatio.sort(key=lambda x: x.ratio, reverse=True)


#detecting hotspots of each list by median

'''

k1 = 0.5
k2 = 0.5

i = 0 
for x in sortedCsAvr:
	if ( i <= len(sortedCsAvr) * k1 ):
		x.isTopAvr(True)
	i += 1

i = 0 
for x in sortedCsRatio:
	if ( i <= len(sortedCsRatio) * k2 ):
		x.isTopRatio(True)
	i += 1

'''

#detecting hotspots of each list by mean

totalAvrSum = 0 
totalRatioSum = 0
i = 0

for x in NZcslist: 
	totalRatioSum = totalRatioSum + x.ratio
	totalAvrSum = totalAvrSum + x.avr
	i += 1

totalAvrMean = totalAvrSum / len(NZcslist) 
totalRatioMean = totalRatioSum / len(NZcslist)


# classify
for x in sortedCsAvr:
	if ( x.avr >= totalAvrMean ):
		x.isTopAvr(True)

for x in sortedCsRatio:
	if ( x.ratio >= totalRatioMean ):
		x.isTopRatio(True)

# print
for x in NZcslist:
	print("##cs lists: ", x.typ, " ", x.csid, " ", x.fid, " " , x.result ,  " avr: ", x.avr, " sum:", x.summ, " ratio: ", x.ratio, " min: ", x.minVal," max: ", x.maxVal, " topAvr: ", x.topAvr, " topRatio: " , x.topRatio, "\n")
print(len(NZcslist))
print(totalRatioMean)

counterY = 0
counterM = 0
counterN = 0


## WRITE OUT RESULTS

# Hotspots based on my definition
f = open("Hotspots.txt","w")
f.write("Is this code region a hotspot? \n")
for x in NZcslist:
	if (x.topAvr == True and x.topRatio == True):
		counterY += 1
		f.write(str(x.csid) + " " + str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is YES"+"\n")
	if (x.topAvr != x.topRatio):
		counterM += 1
		f.write(str(x.csid) + " " +str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is MAYBE"+"\n")
	if (x.topAvr == False and x.topRatio == False):
		counterN += 1
		f.write(str(x.csid) + " " +str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is NO"+"\n")
	#f.write(" "+ str(x.topAvr)+" "+ str(x.topRatio)+"\n")
f.write("Number of YES code regions: " + str(counterY) + " \n")
f.write("Number of MAYBE code regions: " + str(counterM) + " \n")
f.write("Number of NO code regions: " + str(counterN) + " \n")
f.write("Number of Non-zero code regions: " + str(counterN+counterM+counterY) + " \n")
f.close()

# Hotspots based on definition 1, related work for the hotspot paper
counterD1 = 0
f1 = open("Hotspots_D1.txt","w")
f1.write("Hotspots based on D1: \n")
for x in NZcslist:
	if (x.maxVal >= 0.01 * maxCS.maxVal):
		counterD1 += 1
		f1.write(str(x.csid) + " " + str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is YES"+"\n")
	else:
		f1.write(str(x.csid) + " " +str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is NO"+"\n")

f1.write("Number of hotspots by D1: " + str(counterD1) + " \n")
f1.close()


# Hotspots based on definition 2, related work for the hotspot paper
counterD2 = 0
accum =0
f2 = open("Hotspots_D2.txt","w")
f2.write("Hotspots based on D2: \n")
for x in sortedCsAvr:
	accum = accum + x.maxVal
	if accum <= maxCS.maxVal * 2:
		counterD2 += 1
		f2.write(str(x.csid) + " " + str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is YES"+"\n")
	else:
		f2.write(str(x.csid) + " " +str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is NO"+"\n")

f2.write("Number of hotspots by D2: " + str(counterD2) + " \n")
f2.close()

# Hotspots based on definition 3 for extra-p, related work for the hotspot paper
f3 = open("Hotspots_D3_extrap.txt","w")
f3.write("PARAMETER n\n\n")
#f3.write("POINTS ( 10 )\nPOINTS ( 20 )\nPOINTS ( 30 )\n\n")
f3.write("POINTS ( 5 )\nPOINTS ( 10 )\nPOINTS ( 15 )\nPOINTS ( 20 )\nPOINTS ( 30 )\n\n")
for x in NZcslist:
	f3.write("REGION CR"+str(x.csid)+"\n")
	for j in x.result:
		f3.write("DATA "+ str(j)+ "\n")
	f3.write("\n")
f3.close()

# Hotspots based on definition 4, related work for the hotspot paper
counterD4 = 0
f4 = open("Hotspots_D4.txt","w")
f4.write("Hotspots based on D4: \n")
for x in NZcslist:
	if x.delta > x.avr :
	#if numpy.var(x.result) >  x.avr * 0.1:
		counterD4 += 1
		f4.write(str(x.csid) + " " + str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is YES"+"\n")
	else:
		f4.write(str(x.csid) + " " +str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is NO"+"\n")

f4.write("Number of hotspots by D4: " + str(counterD4) + " \n")
f4.close()

# Hotspots based on definition 3, related work for the hotspot paper
counterD5 = 0
f5 = open("Hotspots_D3.txt","w")
f5.write("Hotspots based on D3: \n")
for x in NZcslist:
	#if x.delta > x.avr * 0.1:
	if x.maxVal / x.minVal >  1:
		counterD5 += 1
		f5.write(str(x.csid) + " " + str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is YES"+"\n")
	else:
		f5.write(str(x.csid) + " " +str(x.name)+" at "+str(x.fid)+":"+str(x.lineNum)+" is NO"+"\n")

f5.write("Number of hotspots by D3: " + str(counterD5) + " \n")
f5.close()

print("End")

