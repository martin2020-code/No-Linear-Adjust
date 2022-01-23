clear all; clf;
%We load the packge for to do nolinear adjust
pkg load optim;

%graphics_toolkit ("qt")
graphics_toolkit ("gnuplot");
%graphics_toolkit ("fltk")

name = input("Nombre de archivo (.csv): ", "s");
delimiter = input("Delimitador de datos: ", "s");

% Function that will be fit
function [y]=sin_func(x,par)
  y=par(1)*sin(2*pi*par(2)*x+par(3));
end

% Operaciones de lectura del fichero
file = fopen(name, 'r');
m=textscan(file, '%f %f', 'delimiter', delimiter);
x = transpose(m{1});
x = x - x(1);
x = 10**(-6)*x; %the data in x variable need to be scaled
y_exp = transpose(m{2});
n = length(x);

%Parameters of adjust
%A = 1090;
%fr = 511;
%ph = 0.1;
A = input("Amplitud(A): ");
fr = input("Frecuencia en Hz(fr): ");
ph = input("Fase en radianes(ph): ");

printf("\n")
printf("=========================================================\n")
printf("No linear regression with the: Levenberg-Marquardt method\n")
printf("=========================================================\n")
printf("number of data input: %d", n)
% Generate a line
printf("\nParameters of adjust: \n")
printf("Amplitud: %0.9f\n", A)
printf("Frequancy: %0.9f\n", fr)
printf("Phase: %0.9f\n", ph)

%x=[0:0.00001:0.001]';
%y_teo=A*sin(2*pi*fr*x+ph);
 
% Add some noise to the line
sigma=0.1;
weights=ones(size(x))/sigma;
%y=y+randn(size(x))*sigma;

% Perform the fit
pin=[A,fr,ph];
[f,p,cvg,iter,corp,covp, covr, stdresid, Z, r2]=leasqr(x,y_exp,pin,"sin_func",0.0001,30);
%[f,p,cvg,iter,corp,covp, covr, stdresid, Z, r2]=leasqr(x,y_exp,pin,"sin_func",.00001,20,weights);

error = sqrt(diag(covp)); 
% Print out the results
printf("\nParameters after adjust: \n")
printf("\nNumber of iterations used: %0.2f\n", iter)
printf("Amplitud: %0.9f\n", p(1))
printf("Frequancy: %0.9f\n", p(2))
printf("Phase: %0.9f\n", p(3))

printf("\nErrors of parameters after adjust: \n")
printf("Error-Amplitud: %0.9f\n", error(1))
printf("Error-Frequancy: %0.9f\n",error(2))
printf("Error-Phase: %0.9f\n", error(3))

p;
covp;
covr;
stdresid;
r2;
chi_sqr = sum((y_exp-sin_func(x,p)).^2);

printf("\nNo linear correlation adjust: %0.9f", r2)
printf("\nChi Sqr: %0.9f\n", chi_sqr);

 
% Plots
%graphics_toolkit ("fltk")

num = n*100;
x_teo = linspace(x(1),x(n),num);
y_teo = sin_func(x_teo,p);

figure(1);
plot(x,y_exp,"ob", x_teo, y_teo, "-r");

xlabel ("t");
ylabel ("A*sin(2*pi*f*t+ph)");
title ("No linear Adjust");
legend("show");
print -djpg figNoLinearAdjust.jpg

figure(2);
plot(x_teo, y_teo, "-r");

%%Saving the adjust data
filename = "adjustData.csv"
file2 = fopen(filename, 'w');
fprintf(file2, "exp data;exp data;teo data;teo data\n")
fprintf(file2, "time(s);amp(volt);time(s);amp(volt)\n")
for i=1:1:num
	if (i <= n)
		fprintf(file2, "%0.6f;%0.6f;%0.6f;%0.6f\n",x(i), y_exp(i), x_teo(i), y_teo(i));
	else
		fprintf(file2, ";;%0.6f;%0.6f\n", x_teo(i), y_teo(i));
	end
end	
fclose(file2);

%graphics_toolkit ("fltk")
%figure(2);
%subplot(2,1,1)
%hold on;
%errorbar(x,y_exp,1./weights);
%plot(x,sin_func(x,p));
%plot(x,y_exp);
 
%subplot(2,1,2);
%errorbar(x,y_exp-sin_func(x,p),1./weights);
