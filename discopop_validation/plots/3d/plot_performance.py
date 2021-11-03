import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import pandas as pd

fileDir = "data.csv"

data = pd.read_csv(fileDir, engine = 'c', float_precision = 'round_trip', dtype=np.float64)

dataTop = data.drop_duplicates(subset=['paths', 'operations'], keep='first', inplace=False)
XTop = dataTop['paths']
YTop = dataTop['operations']
ZTop = dataTop['time']

dataMid = data.drop_duplicates(subset=['paths', 'operations'], keep=False, inplace=False)
XMid = dataMid['paths']
YMid = dataMid['operations']
ZMid = dataMid['time']

dataBottom = data.drop_duplicates(subset=['paths', 'operations'], keep='last', inplace=False)
XBottom = dataBottom['paths']
YBottom = dataBottom['operations']
ZBottom = dataBottom['time']

fig = plt.figure(figsize=(11.5, 8.5))
ax = fig.add_subplot(111, projection='3d')

ax.plot_trisurf(XTop, YTop, ZTop, cmap='viridis', alpha=0.5)
ax.plot_trisurf(XMid, YMid, ZMid, cmap='viridis', alpha=0.5)
ax.plot_trisurf(XBottom, YBottom, ZBottom, cmap='viridis', alpha=0.5)

plt.show()