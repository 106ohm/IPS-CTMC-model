%% parameters setting

%lambdaU = 1.14e-4; % once every year
lambdaU = 3.42e-4; % once every four months
muU = 2;

lambdaD = 0.125; % 16*0.125=2, meaning that at maximum load the expected utility recovery time is equal to battery discharge time
lambdaD_MR = lambdaD/2; % half of lambdaD (consider the capacity of a single MR battery to be equal to the capacity of two SR batteries)

Load = 80; % kW, typical values from 50 to 100 kW
ModulePower = 10;% kW
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

%% start evaluation
start=50;
stop=600;
steps=10;
numberOfEvaluations = ceil((stop-start)/steps);

A_SR = zeros(numberOfEvaluations,1);
A_MR = zeros(numberOfEvaluations,1);
A_IR = zeros(numberOfEvaluations,1);
A_CR = zeros(numberOfEvaluations,1);
MTBF_SR = zeros(numberOfEvaluations,1);
MTBF_MR = zeros(numberOfEvaluations,1);
MTBF_IR = zeros(numberOfEvaluations,1);
MTBF_CR = zeros(numberOfEvaluations,1);
I_SR = zeros(numberOfEvaluations,1);
I_IR = zeros(numberOfEvaluations,1);
I_CR = zeros(numberOfEvaluations,1);
r = zeros(numberOfEvaluations,1);
counter=1;
for i = start:steps:stop
  r(counter) = i;

  % Rectifiers Redundancy (MR)
  lambdaB_MR = lambdaB_SR;
  lambdaR_MR = r_MR*r(counter)*lambdaR_SR;
  lambdaI_MR = r_MR*r(counter)*lambdaI_SR;
  muB_MR = muB_SR;% hours^(-1)
  muR_MR = muR_SR;

% Independent Redundancy (IR)
  lambdaB_IR = r_IR*r(counter)*lambdaB_SR;
  lambdaR_IR = r_IR*r(counter)*lambdaR_SR;
  lambdaI_IR = r_IR*r(counter)*lambdaI_SR;
  muB_IR = muB_SR;% hours^(-1)
  muR_IR = muR_SR;

% Component Redundancy (CR)
  lambdaB_CR = r_CR*r(counter)*lambdaB_SR;
  lambdaR_CR = r_CR*r(counter)*lambdaR_SR;
  lambdaI_CR = r_CR*r(counter)*lambdaI_SR;
  muB_CR = muB_SR;% hours^(-1)
  muR_CR = muR_SR;

  [A_SR(counter),MTTF_SR,MTBF_SR(counter)] = evaluate_SR(n,lambdaB_SR,lambdaR_SR,lambdaI_SR,lambdaU,lambdaD,muB_SR,muR_SR,muU);
  [A_MR(counter),MTTF_MR,MTBF_MR(counter)] = evaluate_MR(nm,n,lambdaB_MR,lambdaR_MR,lambdaI_MR,lambdaU,lambdaD_MR,muB_MR,muR_MR,muU);
  [A_IR(counter),MTTF_IR,MTBF_IR(counter)] = evaluate_IR(nm,n,lambdaB_IR,lambdaR_IR,lambdaI_IR,lambdaU,lambdaD,muB_IR,muR_IR,muU);
  [A_CR(counter),MTTF_CR,MTBF_CR(counter)] = evaluate_CR(nm,n,lambdaB_CR,lambdaR_CR,lambdaI_CR,lambdaU,lambdaD,muB_CR,muR_CR,muU);
  %
  I_SR(counter) = 100*( MTBF_SR(counter)-MTBF_MR(counter) )/MTBF_MR(counter);
  I_IR(counter) = 100*( MTBF_IR(counter)-MTBF_MR(counter) )/MTBF_MR(counter);
  I_CR(counter) = 100*( MTBF_CR(counter)-MTBF_MR(counter) )/MTBF_MR(counter);

  counter = counter + 1;
end


csvwrite('results-AC-r17-muU2-lambdaD0.125-varyingR.csv', [r I_SR I_IR I_CR]);
