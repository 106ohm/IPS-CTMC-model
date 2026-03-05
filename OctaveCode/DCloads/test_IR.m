%% parameters setting

%% utility (almost) never fails
%lambdaU = 1.e-12;
%muU = 1.e+10;
%% utility (almost) immediately fails and never recover
%lambdaU = 1.e+10;
%muU = 1.0e-12;

lambdaU = 1.14e-4; % once every year
muU = 1;

lambdaD = 2;

% System Redundancy (SR)
lambdaB_SR = 11.76e-6;% hours^(-1)
lambdaR_SR = 16.6e-6;
muB_SR = 0.5;% hours^(-1)
muR_SR = muB_SR;

% Component Redundancy (CR)
lambdaB_CR = 17*lambdaB_SR;
lambdaR_CR = 17*lambdaR_SR;
muB_CR = 0.5;% hours^(-1)
muR_CR = muR_SR;


ModulePower = 10;% kW
minLoad = 40;% kW
loadStep = 20;% kW

%% start evaluation
numberOfEvaluations = 6;

i=2;

Load = minLoad + i*loadStep % kW, typical values from 50 to 100 kW

n = ceil(Load/ModulePower)
nm = n+3;% nm is n+m

[A_LR,MTTF_LR,MTBF_LR_value] = evaluate_IR(nm,n,lambdaB_CR,lambdaR_CR,lambdaU,lambdaD,muB_CR,muR_CR,muU);

A_LR
MTTF_LR
MTBF_LR_value
