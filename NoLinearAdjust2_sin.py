#Ajuste No lineal para una funcion senoidal
#Programa para realizar un ajsute lineal en python
import numpy as np
import matplotlib.pyplot as plt
import fit_leastsq as f_l #libreria para ajusta los datos
import random as rand
import time as tm

#Funcion para convertir string a float, devueve un lista np
def str2float(lst):
	return np.array([float(i) for i in lst])

#Definicion de funcion de ajuste
def sinF(x, p0,p1,p2,p3):
	return p0*np.sin(2*np.pi*p1*x+p2)+p3
def sinFF(x, p):
	return sinF(x,*p)

#Se pide el nombre de archivo 
print("Nombre de archivo de los datos con extension: ", end="")
name = str(input())
print("Nombre de archivo de los parametros Adj. con extension: ", end="")
namePar = str(input())
print("Delimitador de campo para ambos archivos: ", end="")
delimiter = str(input())
print("# de linea de inicio de datos de ambos archivos: ", end="")
sLine = int(input())
print("Potencia de escala, eje x: ", end="")
xScale = int(input())
print("Numero de ajustes a realizar: ", end="")
numAdjust = int(input())
print("Numero de parametros por ajuste: ", end="")
nPar = int(input())

fileData = np.loadtxt(name,dtype=str, delimiter=delimiter, skiprows = sLine)
filePar = np.loadtxt(namePar,dtype=str, delimiter=delimiter, skiprows = sLine)

#Alamacenamos los parametros de ajuste en una matrix
parM = np.zeros([numAdjust,nPar], dtype=float)

#Se extrae los aparametros
for i in range(0,numAdjust):
	parM[i,:] = str2float(filePar[i,:])

"""
print("Lista de parametros ajustar: ")
for i in range(0, numAdjust):
	print("Adj: ", parM[i:])
"""

plt.figure()
j = 0
rand.seed(tm.time())
for i in range(0,2*numAdjust-1,2):
	x_exp = str2float(fileData[:,i])
	y_exp = str2float(fileData[:,i+1])
	x_exp = (x_exp - x_exp[0])*10**(xScale)
	n = x_exp.size
	x_teo = np.linspace(x_exp[0],x_exp[n-1],n*3)
	
	"""
	print("Parametros de ajuste iniciales: ")
	print("Amplitud: ", end="")
	A = float(input())
	print("Frecuencia (Hz): ", end="")
	F = float(input())
	print("Fase (Radianes): ", end="")
	PH = float(input())
	print("DC level: ", end="")
	DC = float(input())
	"""
	j = int((i+1)/2)
	p_start = parM[j,:]
	print("\nStart Parameters for Adj. {}: {}".format(j,p_start))

	#p_start = [A, F, PH, DC]

	pfit_ls, perr_ls = f_l.fit_leastsq(p_start, x_exp, y_exp, sinFF)
	chi_sq = sum((sinFF(x_exp, pfit_ls) - y_exp)**2/sinFF(x_exp, pfit_ls))
	print("# Fit{} parameters and parameter errors from lestsq method :".format(j))
	print("pfit{} = {}".format(j,pfit_ls))
	print("perr{} = {}".format(j,perr_ls))
	print("Chi{}_2 = {}".format(j,chi_sq))
	
	#color for graphs
	r = rand.random()
	g = rand.random()
	b = rand.random()
	#plt.figure()
	plt.plot(x_exp,y_exp, "o", label = "Exp.Data", color=(r,g,b))
	plt.plot(x_teo,sinFF(x_teo, pfit_ls), "--", label = "No Linear Adj.", color=(r,g,b))

plt.xlabel("x_data(Unit)")
plt.ylabel("y_data(Unit)")
plt.title("Title1")
plt.legend()
plt.savefig("noLinearAdjustM.png")
plt.show()
##Ajuste lineal##
