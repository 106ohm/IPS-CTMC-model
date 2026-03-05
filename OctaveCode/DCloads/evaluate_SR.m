function [A, MTTF, MTBF] = evaluate_SR(n,lambdaB,lambdaR,lambdaU,lambdaD,muB,muR,muU)

%% model definition
% notice: here last state is the system failed state
[Qre,Qav,pi0,av_indx] = CTMC_SR(n,lambdaB,lambdaR,lambdaU,lambdaD,muB,muR,muU);

%% solution of the availability model
tildeQ = Qav;
tildeQ(:,end) = ones(3+3,1);

en = zeros(1,3+3);
en(end) = 1;

% steady-state probability vector
pi = (tildeQ')\(en');

% availability = MTTF/MTBF
A = sum(pi(1:end-1));

%% solution of the reliability model
hatQ = Qre(av_indx,av_indx);

hatpi0 = pi0(av_indx);

tau = -(hatQ')\(hatpi0');

MTTF = (tau')*ones(length(av_indx),1);

%% evaluate MTBF
MTBF = MTTF/A;


end
