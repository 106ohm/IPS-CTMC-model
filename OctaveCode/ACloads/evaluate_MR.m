function [A,MTTF,MTBF] = evaluate_MR(nm,n,lambdaB,lambdaR,lambdaI,lambdaU,lambdaD,muB,muR,muU)

%% model definition
[nstates, Qav, Qre, pi0, av_indx, sys_failure_indx] = CTMC_MR(nm,n,lambdaB,lambdaR,lambdaI,lambdaU,lambdaD,muB,muR,muU);  

%% solution of the availability model
tildeQ = Qav;
tildeQ(:,end) = ones(nstates,1);

elast = zeros(1,nstates);
elast(end) = 1;

% steady-state probability vector
pi = (tildeQ')\(elast');

% availability = MTTF/MTBF
A = sum(pi(av_indx));

%% solution of the reliability model
hatQ = Qre(av_indx,av_indx);

hatpi0 = pi0(av_indx);

tau = -(hatQ')\(hatpi0');

MTTF = (tau')*ones(length(av_indx),1);

%% evaluate MTBF
MTBF = MTTF/A;

%fprintf("Percentage of up states is %f\n", 100.0*length(av_indx)/nstates);

end
