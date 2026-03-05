function [Qre,Qav,pi0,av_indx] = CTMC_SR(n,lambdaB,lambdaR,lambdaU,lambdaD,muB,muR,muU)
%CTMC_SR infinitesimal generator matrix and initial probability vector
% of the System Redundancy (SR) Continuous Time Markov Chain (CTMC)
%   lambdaB : battery failure rate
%   lambdaR : rectifier failure rate
%   lambdaU : utility failure rate
%   lambdaD : single module battery discharge rate
%   muB     : battery recovery rate
%   muR     : rectifier recovery rate
%   muU     : utility recovery rate

Rav = zeros(3+3,3+3);
Rre = zeros(3+3,3+3);

av_indx = [1 2 4 5];

% model btteries and rectifiers fault and recovery when the utility is OK
Rre(1,2) = 2*(lambdaB + lambdaR);
Rre(2,1) = muB;
Rre(2,3) = lambdaB + lambdaR;

% model btteries fault and recovery when the utility is KO
Rre(3+1,3+2) = 2*lambdaB+n*lambdaD;
Rre(3+2,3+1) = muB;
Rre(3+2,3+3) = lambdaB+n*lambdaD;

% model utility fault and recovery
Rre(1,3+1) = lambdaU;
Rre(2,3+2) = lambdaU;
Rre(3+1,1) = muU;
Rre(3+2,2) = muU;

% % Plot reliability model
% D= digraph(R);
% Plot = plot(D);
% highlight(Plot,3,'NodeColor','r');
% highlight(Plot,'Edges',inedges(D,3)','EdgeColor','r');

Rav = Rre;
Rav(3,2) = muB;
Rav(3+3,3+2) = muB;

Qre = Rre - diag(Rre*ones(3+3,1));
Qav = Rav - diag(Rav*ones(3+3,1));

pi0 = zeros(1,3+3);
pi0(1) = 1;

end
