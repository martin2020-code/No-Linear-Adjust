clear all; clf;
%We load the packge for to do nolinear adjust
pkg load optim

%graphics_toolkit ("qt")
%graphics_toolkit ("gnuplot")
%graphics_toolkit ("fltk")

% Function that will be fit
function [y]=func(x,par)
  y=par(1)*(exp(-x/par(2))) + par(3);
end
 
% Operaciones de lectura del fichero
%remember to replace the name of the data file
filedata = 'dataEXP3.csv';
file = fopen(filedata, 'r');
m=textscan(file, '%f %f', 'delimiter', ';');
x = transpose(m{1});
%x = the data in x variable need to be scaled
y_exp = transpose(m{2});
n = length(x);

%Parameters of adjust
v0 = 10;
tau = 1;
off = 0;
%off_x = 0;

printf("\n")
printf("=========================================================\n")
printf("No linear regression with the: Levenberg-Marquardt method\n")
printf("=========================================================\n")
printf("number of data input: %d", n)
% Generate a line
printf("\nParameters of adjust: \n")
printf("v0: %0.3f\n", v0)
printf("tau: %0.3f\n", tau)
printf("off: %0.3f\n", off)

% Add some noise to the line
sigma=0.01;
weights=ones(size(x))/sigma;

% Perform the fit
pin=[v0,tau,off];
[f,p,cvg,iter,corp,covp, covr, stdresid, Z, r2]=leasqr(x,y_exp,pin,"func",0.00001,500);
%[f,p,cvg,iter,corp,covp, covr, stdresid, Z, r2]=leasqr(x,y_exp,pin,"sin_func",.00001,20,weights);

error = sqrt(diag(covp)); 
% Print out the results

printf("\nParameters after regression: \n")
printf("\nNumber of iterations used: %0.2f\n", iter)
printf("v0: %0.6f\n", p(1))
printf("tau: %0.6f\n", p(2))
printf("off: %0.6f\n", p(3))

printf("\nDispertion of parameters after regression: \n")
printf("Error-v0: %0.6f\n", error(1))
printf("Error-tau: %0.6f\n",error(2))
printf("Error-off: %0.6f\n", error(3))

p;
covp;
covr;
stdresid;
r2;
chi_sqr = sum((y_exp-func(x,p)).^2);

printf("\nNo linear correlation adjust: %0.5f", r2)
printf("\nChi Sqr: %0.5f\n", chi_sqr);

 
% Plots
graphics_toolkit ("fltk")
figure(1);
num = n*100
x_teo = linspace(x(1),x(end),num);
y_teo = func(x_teo,p);
plot(x,y_exp, "ob", x_teo, y_teo, "-r")
xlabel ("t(s)");
ylabel ("V(volts)");
title ("No linear Adjust");
legend("show");
print figNoLinearAdjust.png

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

graphics_toolkit ("fltk")
figure(2);
subplot(2,1,1)
hold on;
errorbar(x,y_exp,1./weights);
plot(x,func(x,p));
%plot(x,y_exp);
 
subplot(2,1,2);
errorbar(x,y_exp-func(x,p),1./weights);
