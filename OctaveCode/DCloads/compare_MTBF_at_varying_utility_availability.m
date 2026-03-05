%% parameters setting

muU = 2;

lambdaD = 0.125; % 16*0.125=2, meaning that at maximum load the expected utility recovery time is equal to battery discharge time

r = 17;

Load = 80; % kW, typical values from 50 to 100 kW
n = ceil(Load/ModulePower);
nm = n+3;% nm is n+m

% System Redundancy (SR)
lambdaB_SR = 11.76e-6;% hours^(-1)
lambdaR_SR = 16.6e-6;
muB_SR = 0.5;% hours^(-1)
muR_SR = muB_SR;

% Rectifiers Redundancy (MR)
lambdaB_MR = lambdaB_SR;
lambdaR_MR = r*lambdaR_SR;
muB_MR = muB_SR;% hours^(-1)
muR_MR = muR_SR;

% Independent Redundancy (IR)
lambdaB_IR = r*lambdaB_SR;
lambdaR_IR = r*lambdaR_SR;
muB_IR = muB_SR;% hours^(-1)
muR_IR = muR_SR;

% Component Redundancy (CR)
lambdaB_CR = r*lambdaB_SR;
lambdaR_CR = r*lambdaR_SR;
muB_CR = muB_SR;% hours^(-1)
muR_CR = muR_SR;

%% start evaluation
numberOfEvaluations = 6;
A_U = zeros(numberOfEvaluations,1);
A_SR = zeros(numberOfEvaluations,1);
A_MR = zeros(numberOfEvaluations,1);
A_IR = zeros(numberOfEvaluations,1);
A_CR = zeros(numberOfEvaluations,1);
MTBF_SR = zeros(numberOfEvaluations,1);
MTBF_MR = zeros(numberOfEvaluations,1);
MTBF_IR = zeros(numberOfEvaluations,1);
MTBF_CR = zeros(numberOfEvaluations,1);
%
I_SR = zeros(numberOfEvaluations,1);
I_IR = zeros(numberOfEvaluations,1);
I_CR = zeros(numberOfEvaluations,1);
%
Load = zeros(numberOfEvaluations,1);
for i = 1 : numberOfEvaluations

  lambdaU = i*1.14e-4; % i faults every year

  [A_U(i), MTTF_U, MTBF_U] = evaluate_U(lambdaU,muU);
  [A_SR(i),MTTF_SR,MTBF_SR(i)] = evaluate_SR(n,lambdaB_SR,lambdaR_SR,lambdaU,lambdaD,muB_SR,muR_SR,muU);
  [A_MR(i),MTTF_MR,MTBF_MR(i)] = evaluate_MR(nm,n,lambdaB_MR,lambdaR_MR,lambdaU,lambdaD,muB_MR,muR_MR,muU);
  [A_IR(i),MTTF_IR,MTBF_IR(i)] = evaluate_IR(nm,n,lambdaB_IR,lambdaR_IR,lambdaU,lambdaD,muB_IR,muR_IR,muU);
  [A_CR(i),MTTF_CR,MTBF_CR(i)] = evaluate_CR(nm,n,lambdaB_CR,lambdaR_CR,lambdaU,lambdaD,muB_CR,muR_CR,muU);
  %
  I_SR(i) = ( MTBF_SR(i)-MTBF_MR(i) )/MTBF_MR(i);
  I_IR(i) = ( MTBF_IR(i)-MTBF_MR(i) )/MTBF_MR(i);
  I_CR(i) = ( MTBF_CR(i)-MTBF_MR(i) )/MTBF_MR(i);
end


csvwrite('results-r17-muU2-lambdaD0.125-varyingLambdaU.csv', [A_U A_SR MTBF_SR A_MR MTBF_MR A_IR MTBF_IR A_CR MTBF_CR]);
