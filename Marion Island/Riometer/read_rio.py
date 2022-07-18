import matplotlib as mpl
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook
import matplotlib.dates as md
import datetime as dt
import time
from matplotlib.dates import date2num


def read_datafile(file_name):
    data = np.loadtxt(	file_name, 
						delimiter = ',', 
						dtype = str, 	
						converters = {	0: lambda s: md.date2num(dt.datetime.strptime(s.strip('"'), '%Y/%m/%d %H:%M:%S')),
										3: lambda t: t.replace('+', ''),
										4: lambda u: u.replace('+', '')
										},
						usecols = (0,3,4)
					)
    return data

data = read_datafile('./20180421.sec')

date = data[:,0]
ch1 = map(int, data[:,1])
ch2 = map(int, data[:,2])

# print ch2
# for i in range(lben(ch1)):
# 	ch1[i] = float(ch1[i])http://polaris.nipr.ac.jp/~iriosyo/QL/brio/MAR/2018/brio_mar_raw20180421.png
# 	ch2[i] = float(ch2[i])

fig = plt.figure()
ax1 = fig.add_subplot(211)

ax2 = fig.add_subplot(212, sharex=ax1, sharey=ax1)
ax2.set_xlabel('Time (UTC)')
# fig.autofmt_xdate()
ax1.plot_date(date, ch1, 'b-', c='r', label='Channel 1')
ax2.plot_date(date, ch2, 'b-', c='b', label='Channel 1')

plt.show()