function [A, MTTF, MTBF] = evaluate_U(lambdaU,muU)

two_states = 2;

Qre = [-lambdaU lambdaU
       0        0];

Qav = [-lambdaU lambdaU
       muU -muU];

pi0 = [1;0];

transient_indx = [1];

% solution of the availability model
tildeQ = Qav;
tildeQ(:,end) = ones(two_states,1);

elast = zeros(1,two_states);
elast(end) = 1;

% steady-state probability vector
pi = (tildeQ')\(elast');

% availability = MTTF/MTBF
A = sum(pi(transient_indx));

%% solution of the reliability model
hatQ = Qre(transient_indx,transient_indx);

hatpi0 = pi0(transient_indx);

tau = -(hatQ')\(hatpi0');

MTTF = (tau')*ones(length(transient_indx),1);

%% evaluate MTBF
MTBF = MTTF/A;
end
