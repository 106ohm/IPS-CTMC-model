function [nstates, Qav, Qre, pi0, av_indx, sys_failure_indx] = CTMC_CR(nm,n,lambdaB,lambdaR,lambdaU,lambdaD,muB,muR,muU)
%CTMC_CR infinitesimal generator matrix and initial probability vector
% of the Component Redundancy (CR) Continuous Time Markov Chain (CTMC)
%   nm      : number of hot standby (n+m>=n+1)
%   n       : number of required rectifiers or batteries to address load
%   lambdaB : battery failure rate
%   lambdaR : rectifier failure rate
%   lambdaU : utility failure rate
%   muB     : battery recovery rate
%   muR     : rectifier recovery rate
%   muU     : utility recovery rate

%%% UPS model when the utility is OK %%%
UOK_aus = nm-n+2;% number of states only considering rectifiers
UOK_nstates = UOK_aus^2;

UOK_eaus = zeros(1,UOK_aus);
UOK_eaus(end) = 1;
UOK_av_indx = find(kron(ones(1,UOK_aus), UOK_eaus)+kron(UOK_eaus, ones(1,UOK_aus))<1);

% define rectifiers' and batteries' behavior
UOK_Rr_failure = diag(lambdaR*[nm:-1:n],1);
UOK_Rb_failure = diag(lambdaB*[nm:-1:n],1);

UOK_Rre = kron(UOK_Rr_failure, eye(UOK_aus, UOK_aus)) + kron(eye(UOK_aus, UOK_aus), UOK_Rb_failure);
UOK_Rre(UOK_av_indx(2:end),1) = muB;

UOK_Rav = UOK_Rre;
UOK_Rav(2:end,1) = muB;

%%% UPS model when the utility is KO %%%
UKO_nstates = nm-n+2;% number of states only considering batteries

UKO_av_indx = [1:nm-n+1];

% define batteries' behavior
UKO_Rre = diag(lambdaB*[nm:-1:n]+n*lambdaD*ones(1,nm-n+1),1);
UKO_Rre(2:end-1,1) = muB;

UKO_Rav = UKO_Rre;
UKO_Rav(end,1) = muB;

%%% Model of the entire system %%%

nstates = UOK_aus^2+UOK_aus;

av_indx = [UOK_av_indx UOK_nstates+UKO_av_indx];

% when the utility recovers the number of ok rectifiers is the same
% as before utility fault
ConnectionUtilityFailure = kron(eye(UOK_aus), [1; zeros(UOK_aus-1,1)]);
ConnectionUtilityRecovery = kron([1 zeros(1,UOK_aus-1)], eye(UOK_aus));

Rre = [UOK_Rre lambdaU*ConnectionUtilityFailure
       muU*ConnectionUtilityRecovery UKO_Rre];

%spy(Rre)

Rav = [UOK_Rav lambdaU*ConnectionUtilityFailure
       muU*ConnectionUtilityRecovery UKO_Rav];

% Notice that here we have 2 system failure states, those with index
sys_failure_indx = [UOK_aus^2, UOK_aus^2+UOK_aus];

% % Plotting reliability model
% D= digraph(Rre);
% Plot = plot(D);
% highlight(Plot,[5,10,15,20,21,22,23,24,25],'NodeColor','r');
% highlight(Plot,'Edges',[inedges(D,5)',inedges(D,10)',inedges(D,15)',inedges(D,20)',...
%     inedges(D,21)',inedges(D,22)',inedges(D,23)',inedges(D,24)',inedges(D,25)'],'EdgeColor','r');

Qav = Rav - diag(Rav*ones(nstates,1));
Qre = Rre - diag(Rre*ones(nstates,1));

pi0 = zeros(1,nstates);
pi0(1) = 1;

end
