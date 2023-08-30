function dXdt = atn_ode_massbalance(time,X,Data,fluo_deriv,kmix)
% ----------------------------------------------------------------------- %
% ----------------------------- PARAMETERS ------------------------------ %
% ----------------------------------------------------------------------- %

% ----------------------------------------------------------------------- %
% FEEDING LINKS
% ----------------------------------------------------------------------- %

% Feeding links between feeders and food
communityMatrix = Data.communityMatrix;
% Functional response exponent parameters for each feeding link
q = Data.q;
% Feeding interference coefficients for each feeding link
d = Data.d;
% Relative food preferences of feeders for each feeding link
omega = Data.omega;
% Assimilation efficiencies for each feeding link
e = Data.e;
% Maximum consumption rates for each feeding link
y = Data.y;
% Half saturation constants to the power of q for each feeding link
B0_pow_q = Data.B0_pow_q;

% ----------------------------------------------------------------------- %
% PRODUCERS
% ----------------------------------------------------------------------- %

% Carrying capacity of autotrophs for current year
K = Data.K(Data.year);
% Intrinsic growth rate of producers
r = Data.r;
% Competition coefficients of producers
c = Data.c;

% ----------------------------------------------------------------------- %
% CONSUMERS AND FISHES
% ----------------------------------------------------------------------- %
% Metabolic rate of consumers and fishes
x = Data.x;
% Fractions of assimilated C used for biomass gains for feeders
ax = Data.ax;
% Fractions of assimilated C respired by maintenance for feeders
bx = Data.bx;


% ----------------------------------------------------------------------- %
% MISC
% ----------------------------------------------------------------------- %
% Precalculated index vectors etc.
GuildInfo = Data.GuildInfo;

% New variables for speed up by avoiding repetitive computations or indexing
B = X(1:GuildInfo.nGuilds+1);

% ----------------------------------------------------------------------- %
% extinction threshold
B(B< 1.00000000000000e-06) = 0;
% ----------------------------------------------------------------------- %

% Producer biomasses
bProducerGuilds = B(GuildInfo.iProducerGuilds);
% Consumer biomasses
bConsumerGuilds = B(GuildInfo.iConsumerGuilds);
% Feeder biomasses
bFeederGuilds = B(GuildInfo.iFeederGuilds);
% Food biomasses
bFoodGuilds = B(GuildInfo.iFoodGuilds);
% ----------------------------------------------------------------------- %

% ----------------------------------------------------------------------- %
% OMEGA VARIABLE
% ----------------------------------------------------------------------- %
A = bFoodGuilds'.*Data.communityMatrix;
A(A > 0) = 1;
ng = size(A,2);
nps = 1./sum(A,2);
nps(isinf(nps)) = 0;
w = repmat(nps,1,ng);
omega = A.*w; 

% ----------------------------------------------------------------------- %
% -------------------------------- MODEL -------------------------------- %
% ----------------------------------------------------------------------- %

% Preallocate biomass derivative vector
dBdt = zeros(GuildInfo.nGuilds,1);

% ----------------------------------------------------------------------- %
% FUNCTIONAL RESPONSE MATRIX
% ----------------------------------------------------------------------- %

Bmx_pow_q = repmat(bFoodGuilds',GuildInfo.nFeederGuilds,1).^q;
Ftop = omega.*repmat(bFoodGuilds',GuildInfo.nFeederGuilds,1).^q;
Fbot1 = B0_pow_q;
Fbot2 = diag(sum(omega.*Bmx_pow_q,2))*communityMatrix; 
Fbot3 = diag(bFeederGuilds)*d.*B0_pow_q;
Fbot = Fbot1 + Fbot2 + Fbot3;
F = Ftop./Fbot;
F(isnan(F)) = 0;

% ----------------------------------------------------------------------- %
% GAINS AND LOSSES
% ----------------------------------------------------------------------- %

ytimesxtimesBtimesF = y.*repmat(x.*bFeederGuilds,1,GuildInfo.nFoodGuilds).*F;

% Gain from resources
gainMTX = diag(ax)*ytimesxtimesBtimesF;
gainVEC = sum(gainMTX,2);


% Loss to consumers
lossMTX = (ytimesxtimesBtimesF./e)';
lossMTX(isnan(lossMTX)) = 0;
lossVEC = sum(lossMTX,2);

% Loss to maintenance
lConsumerMaintenance = bx.*x.*bConsumerGuilds;

% ----------------------------------------------------------------------- %
% PRODUCER BIOMASS DERIVATIVES
% ----------------------------------------------------------------------- %

% PRODUCER gain from logistic growth
G = 1 - (c'*bProducerGuilds)/K;
gProducerGrowth = r.*bProducerGuilds.*G;

% PRODUCER loss to consumption
lProducerConsumption = lossVEC(GuildInfo.iProducerGuildsInFood_position_vector);

%%%%%%%%%%%%%%%the original below%%%%%%%%%%%%%
dBdt(GuildInfo.iProducerGuilds) = + gProducerGrowth ...
                                  - lProducerConsumption;

%foodweb plankton
dBdt(95)  = dBdt(95) + kmix*max(B(108)-B(95),0);
%baseline plankton
dBdt(107) = 0;
%offshore plankton
dBdt(108) = ppval(fluo_deriv,time);

% ----------------------------------------------------------------------- %
% CONSUMER BIOMASS DERIVATIVES
% ----------------------------------------------------------------------- %

% CONSUMER maintenance loss
lConsumerMaintenance = lConsumerMaintenance;

% CONSUMER gain from consumption
gConsumerConsumption = gainVEC;


% CONSUMER loss to consumption
NewlConsumerConsumption = lossVEC(GuildInfo.iConsumerGuildsInFood_position_vector); 
xxA = 1:GuildInfo.nGuilds; 
xxB = NewlConsumerConsumption'; 
xxBi = GuildInfo.iConsumerGuildsInFood; 
xxAnew = zeros(1,length(xxA)); 
xxAnew(xxBi) = xxB; 
xxAnew1 = xxAnew'; 
lConsumerConsumption2 = xxAnew1(GuildInfo.iConsumerGuilds); 

%-------------------------------------------------------------------------%
dBdt(GuildInfo.iConsumerGuilds) = - lConsumerMaintenance ...
                                  + gConsumerConsumption ...
                                  - lConsumerConsumption2;

% ----------------------------------------------------------------------- %
% CONCATENATE DERIVATIVES OF BIOMASSES, CATCHES, GAIN FISH, GAIN AND LOSS
% ----------------------------------------------------------------------- %
%save('dBdt','dBdt');
dXdt = dBdt;

