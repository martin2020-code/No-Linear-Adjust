import numpy as np
from scipy import optimize

def fit_leastsq(p0, datax, datay, function):

    #Return the difference bewtheen y-yi
    errfunc = lambda p, x, y: function(x,p) - y

    pfit, pcov, infodict, errmsg, success = \
        optimize.leastsq(errfunc, p0, args=(datax, datay), \
                          full_output=1, epsfcn=0.0001)

    if (len(datay) > len(p0)) and pcov is not None:
        s_sq = (errfunc(pfit, datax, datay)**2).sum()/(len(datay)-len(p0))
        pcov = pcov * s_sq
    else:
        pcov = np.inf

    error = [] 
    for i in range(len(pfit)):
        try:
          error.append(np.absolute(pcov[i][i])**0.5)
        except:
          error.append( 0.00 )
    pfit_leastsq = pfit
    perr_leastsq = np.array(error) 
    return pfit_leastsq, perr_leastsq 

#pfit, perr = fit_leastsq(pstart, xdata, ydata, ff)

#print("\n# Fit parameters and parameter errors from lestsq method :")
#print("pfit = ", pfit)
#print("perr = ", perr)