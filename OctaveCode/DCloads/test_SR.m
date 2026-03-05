%% parameters setting

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

i=2;

Load = minLoad + i*loadStep % kW, typical values from 50 to 100 kW

n = ceil(Load/ModulePower)

[A_SR,MTTF_SR,MTBF_SR_value] = evaluate_SR(n,lambdaB_SR,lambdaR_SR,lambdaU,lambdaD,muB_SR,muR_SR,muU);

A_SR
MTTF_SR
MTBF_SR_value
