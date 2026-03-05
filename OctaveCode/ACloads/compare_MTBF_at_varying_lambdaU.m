%% parameters setting

muU_min = 0.5;% once every two hours
muU_max = 2; % once every half an hour

% 16*0.125=2, meaning that at maximum load the expected max utility recovery time is equal to battery discharge time
lambdaD_min = muU_min/16; 
lambdaD_max = muU_max/16; 
lambdaD_MR_min = lambdaD_min/2; % half of lambdaD (consider the capacity of a single MR battery to be equal to the capacity of two SR batteries)
lambdaD_MR_max = lambdaD_max/2; % half of lambdaD (consider the capacity of a single MR battery to be equal to the capacity of two SR batteries)

r = 17;

ModulePower = 10;
Load = 80; % kW, typical values from 50 to 100 kW
n = ceil(Load/ModulePower);
nm = n+3;% nm is n+m
emme=nm-n; % m

r_CR=(log(2)+log(n+emme)+log(1+n+emme))/log(8);
r_IR=(log(4)+log(n+emme))/log(8);
r_MR=(log(4)+log(n+emme))/log(8);

% System Redundancy (SR)
lambdaB_SR = 11.76e-6;% hours^(-1)
lambdaR_SR = 16.6e-6;
lambdaI_SR = lambdaR_SR;
muB_SR = 0.5;% hours^(-1)
muR_SR = muB_SR;

% Rectifiers Redundancy (MR)
lambdaB_MR = lambdaB_SR;
lambdaR_MR = r_MR*r*lambdaR_SR;
lambdaI_MR = r_MR*r*lambdaI_SR;
muB_MR = muB_SR;% hours^(-1)
muR_MR = muR_SR;

% Independent Redundancy (IR)
lambdaB_IR = r_IR*r*lambdaB_SR;
lambdaR_IR = r_IR*r*lambdaR_SR;
lambdaI_IR = r_IR*r*lambdaI_SR;
muB_IR = muB_SR;% hours^(-1)
muR_IR = muR_SR;

% Component Redundancy (CR)
lambdaB_CR = r_CR*r*lambdaB_SR;
lambdaR_CR = r_CR*r*lambdaR_SR;
lambdaI_CR = r_CR*r*lambdaI_SR;
muB_CR = muB_SR;% hours^(-1)
muR_CR = muR_SR;

%% start evaluation
numberOfEvaluations = 6;
%
A_U_min = zeros(numberOfEvaluations,1);
A_SR_min = zeros(numberOfEvaluations,1);
A_MR_min = zeros(numberOfEvaluations,1);
A_IR_min = zeros(numberOfEvaluations,1);
A_CR_min = zeros(numberOfEvaluations,1);
MTBF_SR_min = zeros(numberOfEvaluations,1);
MTBF_MR_min = zeros(numberOfEvaluations,1);
MTBF_IR_min = zeros(numberOfEvaluations,1);
MTBF_CR_min = zeros(numberOfEvaluations,1);
%
I_SR_min = zeros(numberOfEvaluations,1);
I_IR_min = zeros(numberOfEvaluations,1);
I_CR_min = zeros(numberOfEvaluations,1);
%%%
A_U_max = zeros(numberOfEvaluations,1);
A_SR_max = zeros(numberOfEvaluations,1);
A_MR_max = zeros(numberOfEvaluations,1);
A_IR_max = zeros(numberOfEvaluations,1);
A_CR_max = zeros(numberOfEvaluations,1);
MTBF_SR_max = zeros(numberOfEvaluations,1);
MTBF_MR_max = zeros(numberOfEvaluations,1);
MTBF_IR_max = zeros(numberOfEvaluations,1);
MTBF_CR_max = zeros(numberOfEvaluations,1);
%
I_SR_max = zeros(numberOfEvaluations,1);
I_IR_max = zeros(numberOfEvaluations,1);
I_CR_max = zeros(numberOfEvaluations,1);
%
Load = zeros(numberOfEvaluations,1);
lambdaU = zeros(numberOfEvaluations,1);
for i = 1 : numberOfEvaluations

  lambdaU(i) = i*3.42e-4;

  [A_U_min(i), MTTF_U_min, MTBF_U_min] = evaluate_U(lambdaU(i),muU_min);
  [A_SR_min(i),MTTF_SR_min,MTBF_SR_min(i)] = evaluate_SR(n,lambdaB_SR,lambdaR_SR,lambdaI_SR,lambdaU(i),lambdaD_min,muB_SR,muR_SR,muU_min);
[A_MR_min(i),MTTF_MR_min,MTBF_MR_min(i)] = evaluate_MR(nm,n,lambdaB_MR,lambdaR_MR,lambdaI_MR,lambdaU(i),lambdaD_MR_min,muB_MR,muR_MR,muU_min);
  [A_IR_min(i),MTTF_IR_min,MTBF_IR_min(i)] = evaluate_IR(nm,n,lambdaB_IR,lambdaR_IR,lambdaI_IR,lambdaU(i),lambdaD_min,muB_IR,muR_IR,muU_min);
  [A_CR_min(i),MTTF_CR_min,MTBF_CR_min(i)] = evaluate_CR(nm,n,lambdaB_CR,lambdaR_CR,lambdaI_CR,lambdaU(i),lambdaD_min,muB_CR,muR_CR,muU_min);
  %
  I_SR_min(i) = ( MTBF_SR_min(i)-MTBF_MR_min(i) )/MTBF_MR_min(i);
  I_IR_min(i) = ( MTBF_IR_min(i)-MTBF_MR_min(i) )/MTBF_MR_min(i);
  I_CR_min(i) = ( MTBF_CR_min(i)-MTBF_MR_min(i) )/MTBF_MR_min(i);
  %%%
  [A_U_max(i), MTTF_U_max, MTBF_U_max] = evaluate_U(lambdaU(i),muU_max);
  [A_SR_max(i),MTTF_SR_max,MTBF_SR_max(i)] = evaluate_SR(n,lambdaB_SR,lambdaR_SR,lambdaI_SR,lambdaU(i),lambdaD_max,muB_SR,muR_SR,muU_max);
  [A_MR_max(i),MTTF_MR_max,MTBF_MR_max(i)] = evaluate_MR(nm,n,lambdaB_MR,lambdaR_MR,lambdaI_MR,lambdaU(i),lambdaD_MR_max,muB_MR,muR_MR,muU_max);
  [A_IR_max(i),MTTF_IR_max,MTBF_IR_max(i)] = evaluate_IR(nm,n,lambdaB_IR,lambdaR_IR,lambdaI_IR,lambdaU(i),lambdaD_max,muB_IR,muR_IR,muU_max);
  [A_CR_max(i),MTTF_CR_max,MTBF_CR_max(i)] = evaluate_CR(nm,n,lambdaB_CR,lambdaR_CR,lambdaI_CR,lambdaU(i),lambdaD_max,muB_CR,muR_CR,muU_max);
  %
  I_SR_max(i) = ( MTBF_SR_max(i)-MTBF_MR_max(i) )/MTBF_MR_max(i);
  I_IR_max(i) = ( MTBF_IR_max(i)-MTBF_MR_max(i) )/MTBF_MR_max(i);
  I_CR_max(i) = ( MTBF_CR_max(i)-MTBF_MR_max(i) )/MTBF_MR_max(i);
end


csvwrite('results-AC-r17-min-max-muU-varyingLambdaU.csv', [A_U_min A_SR_min MTBF_SR_min A_MR_min MTBF_MR_min A_IR_min MTBF_IR_min A_CR_min MTBF_CR_min A_U_max A_SR_max MTBF_SR_max A_MR_max MTBF_MR_max A_IR_max MTBF_IR_max A_CR_max MTBF_CR_max lambdaU]);
