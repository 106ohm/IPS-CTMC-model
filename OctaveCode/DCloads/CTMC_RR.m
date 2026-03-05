function [nstates, Qav, Qre, pi0, av_indx, sys_failure_indx] = CTMC_RR(nm,n,lambdaB,lambdaR,lambdaU,lambdaD,muB,muR,muU)
%CTMC_LR infinitesimal generator matrix and initial probability vector
% of the Line Redundancy (LR) Continuous Time Markov Chain (CTMC)
%   nm      : number of hot standby (n+m>=n+1)
%   n       : number of required rectifiers or batteries to address load
%   lambdaB : battery failure rate
%   lambdaR : rectifier failure rate
%   lambdaU : utility failure rate
%   lambdaD : single module battery discharge rate
%   muB     : battery recovery rate
%   muR     : rectifier recovery rate
%   muU     : utility recovery rate

%%% UPS model when the utility is OK %%%
UOK_nstates = nm-n+2;

UOK_av_indx = [1:nm-n+1];

% define rectifiers' and batteries' behavior
UOK_Rre = diag(lambdaR*[nm:-1:n],1)+lambdaB*[zeros(nm-n+2,nm-n+1) [ones(nm-n+1,1); 0]];
UOK_Rre(2:end-1,1) = muB;

UOK_Rav = UOK_Rre;
UOK_Rav(end,1) = muB;

%%% UPS model when the utility is KO %%%
UKO_nstates = nm-n+2;

UKO_av_indx = [1:nm-n+1];

% define batteries' behavior
UKO_Rre = (n*lambdaD+lambdaB)*[zeros(nm-n+2,nm-n+1) [ones(nm-n+1,1); 0]];
UKO_Rre(2:end-1,1) = muB;

UKO_Rav = UKO_Rre;
UKO_Rav(end,1) = muB;

%%% Model of the entire system %%%

nstates = UOK_nstates + UKO_nstates;

av_indx = [UOK_av_indx UOK_nstates+UKO_av_indx];

% when the utility recovers the number of ok rectifiers is the same
% as before utility fault
Rre = [UOK_Rre lambdaU*eye(UOK_nstates)
       muU*eye(UKO_nstates) UKO_Rre];

%spy(Rre)

Rav = [UOK_Rav lambdaU*eye(UOK_nstates)
       muU*eye(UKO_nstates) UKO_Rav];

% Notice that here we have 2 system failure states, those with index
sys_failure_indx = [UOK_nstates, UOK_nstates+UKO_nstates];

Qav = Rav - diag(Rav*ones(nstates,1));
Qre = Rre - diag(Rre*ones(nstates,1));

pi0 = zeros(1,nstates);
pi0(1) = 1;

end
