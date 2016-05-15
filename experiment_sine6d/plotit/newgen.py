import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

filepre2 = sys.argv[1]
filepre1 = sys.argv[2]
filepre3 = sys.argv[3]
filepre4 = sys.argv[4]

fname = sys.argv[5]
pltype = sys.argv[6]

ylab = ''
ylim1 = 0
ylim2 = 0
ind = -1
if pltype == 'NLML':
	ylab = "Negative log marginal likelihood (for training)"
	ylim1 = -2000
	ylim2 = 2400
	ind = 0
elif pltype == 'MSEtrain':
	ylab = "Mean Squared error (for training)"
	ylim1 = -0.2
	ylim2 = 2.0
	ind = 2
elif pltype == 'MSEtest':
	ylab = "Mean Squared error (for testing)"
	ylim1 = -0.2
	ylim2 = 3.0
	ind = 1
elif pltype == 'NLPP':
	ylab = "Negative log predictive probability (for testing)"
	ylim1 = -5.0
	ylim2 = 5.0
	ind = 3

 
base2 = [1,2,3,4]

ADDSE_m = []
ADDSE_std = []

ADD2dim_m = []
ADD2dim_std = []

PROJ1_m = [] 
PROJ1_std = [] 

SE_orig_high_dim_m = [] 
SE_orig_high_dim_std = []
 
SE_actual_proj_dim_m = []
SE_actual_proj_dim_std = []

ARD_orig_high_dim_m = []
ARD_orig_high_dim_std = []

ARD_actual_proj_dim_m =  []
ARD_actual_proj_dim_std =  []

for i in [6]:
	actf1 = filepre1 + "_mean_D" + str(i) + "_K-1.csv"
	actf2 = filepre1 + "_std_D" + str(i) + "_K-1.csv"
	
	M1_mean = np.loadtxt(actf1, delimiter = ',')
	SE_orig_high_dim_m.append(M1_mean[ind, 0])
	SE_actual_proj_dim_m.append(M1_mean[ind, 1])
	ARD_orig_high_dim_m.append(M1_mean[ind, 2])
	ARD_actual_proj_dim_m.append(M1_mean[ind, 3])
		

	M1_std = np.loadtxt(actf2, delimiter = ',')
        SE_orig_high_dim_std.append(M1_std[ind, 0])
        SE_actual_proj_dim_std.append(M1_std[ind, 1])
        ARD_orig_high_dim_std.append(M1_std[ind, 2])
        ARD_actual_proj_dim_std.append(M1_std[ind, 3])
	

for i in base2: 
	actf1 = filepre2 + "_mean_D" + str(6) + "_K-1" + "_redk" + str(i) + ".csv"
	actf2 = filepre2 + "_std_D" + str(6) + "_K-1" + "_redk" + str(i) + ".csv"

	M2_mean = np.loadtxt(actf1, delimiter = ',')
	M2_std = np.loadtxt(actf2, delimiter = ',')
 	PROJ1_m.append(M2_mean[ind])
	PROJ1_std.append(M2_std[ind])

for i in [6]: #[2,4,6,8] 
	actf1 = filepre3 + "_mean_D" + str(i) + "_K-1.csv"
	actf2 = filepre3 + "_std_D" + str(i) + "_K-1.csv"

	M5_mean = np.loadtxt(actf1, delimiter = ',')
	M5_std = np.loadtxt(actf2, delimiter = ',')
 	ADDSE_m.append(M5_mean[ind])
	ADDSE_std.append(M5_std[ind])

for i in [6]: 
	actf1 = filepre4 + "_mean_D" + str(i) + "_K-1.csv"
	actf2 = filepre4 + "_std_D" + str(i) + "_K-1.csv"

	M6_mean = np.loadtxt(actf1, delimiter = ',')
	M6_std = np.loadtxt(actf2, delimiter = ',')
 	ADD2dim_m.append(M6_mean[ind])
	ADD2dim_std.append(M6_std[ind])




fig, ax = plt.subplots()

print SE_orig_high_dim_m
print SE_orig_high_dim_std

print
print len(SE_orig_high_dim_m)
print len(SE_orig_high_dim_std)

print
print "----------------------"
print PROJ1_m
print PROJ1_std
print 
print
# Be sure to only pick integer tick locations.
for axis in [ax.xaxis, ax.yaxis]:
    axis.set_major_locator(ticker.MaxNLocator(integer=True))

print "SE", SE_orig_high_dim_m * 3
print "ARD", ARD_orig_high_dim_m * 3
print "PROJ", PROJ1_m
print "ADDSE", ADDSE_m * 3
print "2dimadd", ADD2dim_m * 3

plt.errorbar(base2, SE_orig_high_dim_m * 4, SE_orig_high_dim_std * 4,  label = 'SE-orig-high-dim')
#plt.errorbar(base3, SE_actual_proj_dim_m * 3, SE_actual_proj_dim_std * 3, label = 'SE-actual-proj-dim')
#plt.errorbar(base2, ARD_orig_high_dim_m * 4, ARD_orig_high_dim_std * 4,  label = 'ARD-orig-high-dim')
#plt.errorbar(base2, ARD_actual_proj_dim_m, ARD_actual_proj_dim_std, label = 'ARD-actual-proj-dim')
#plt.errorbar(base2, PROJ1_m, PROJ1_std, label = 'PROJ-matrix')
#plt.errorbar(base2, ADDSE_m * 4, ADDSE_std * 4, label = 'SE-additive-orig-dim')
#plt.errorbar(base2, ADD2dim_m * 4, ADD2dim_std * 4, label = 'SE-pair-additive-orig-dim')
plt.legend(loc = 2, ncol = 2)

plt.axis((0.5, 4.5, ylim1, ylim2))

plt.xlabel('Dimensionality of the reduced space (with d_e = 1)')
plt.ylabel(ylab)
plt.title(pltype + " for " + fname + " function")
#plt.show()
plt.savefig(fname + "_" + pltype + '.png')
