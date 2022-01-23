#Ajuste No lineal para una funcion senoidal
#Programa para realizar un ajsute lineal en python
import numpy as np
import matplotlib.pyplot as plt
import fit_leastsq as f_l #libreria para ajusta los datos

#Funcion para convertir string a float, devueve un lista np
def str2float(lst):
	return np.array([float(i) for i in lst])

#Se pide el nombre de archivo 
print("Nombre de archivo de los datos con extension: ", end="")
name = str(input())
print("Delimitador de campo: ", end="")
delimiter = str(input())
print("# de linea de inicio de datos: ", end="")
sLine = int(input())
print("Potencia de escala eje x: ", end="")
xScale = int(input())

fileData = np.loadtxt(name,dtype=str, delimiter=delimiter, skiprows = sLine)

x_exp = str2float(fileData[:,0])
y_exp = str2float(fileData[:,1])

x_exp = (x_exp - x_exp[0])*10**(xScale)
n = x_exp.size
x_teo = np.linspace(x_exp[0],x_exp[n-1],n*5)

#Definicion de funcion
def sinF(x, p0,p1,p2, p3):
	return p0*np.sin(2*np.pi*p1*x+p2)+p3
def sinFF(x, p):
	return sinF(x,*p)

print("Parametros de ajuste iniciales: ")
print("Amplitud: ", end="")
A = float(input())
print("Frecuencia (Hz): ", end="")
F = float(input())
print("Fase (Radianes): ", end="")
PH = float(input())
print("DC level: ", end="")
DC = float(input())

p_start = [A, F, PH, DC]

pfit_ls, perr_ls = f_l.fit_leastsq(p_start, x_exp, y_exp, sinFF)
chi_sq = sum((sinFF(x_exp, pfit_ls) - y_exp)**2/sinFF(x_exp, pfit_ls))
print("\n# Fit parameters and parameter errors from lestsq method :")
print("pfit = ", pfit_ls)
print("perr = ", perr_ls)
print("Chi_2 = ", chi_sq)

plt.figure()
plt.plot(x_exp,y_exp, "bo", label = "Exp.Data")
plt.plot(x_teo,sinFF(x_teo, pfit_ls), "r--", label = "No Linear Adj.")
plt.plot(x_teo,sinFF(x_teo, p_start), "g--", label = "St. Param.")
plt.xlabel("x_data(Unit)")
plt.ylabel("y_data(Unit)")
plt.title("Title1")
plt.legend()

plt.figure()
plt.plot(x_exp,y_exp, "bo", label = "Exp.Data")
plt.plot(x_teo,sinFF(x_teo, pfit_ls), "r--", label = "No Linear Adj.")
plt.xlabel("x_data (Unit)")
plt.ylabel("y_data (Unit)")
plt.title("Title2")
plt.legend()
plt.savefig("noLinearAdjust.png")
plt.show()
##Ajuste lineal##
