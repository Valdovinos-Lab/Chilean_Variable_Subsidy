%Use the Data file planton_foodweb and plankton_offshore
load Data\ChileanIntertidal_ECIMBiomass_massbalance4.mat 

clock1 = clock;

kmix = 1;

t_init = 0;
t_final = 365*24; %(Should run to 365*24 for actual runs.)
tspan = t_init:t_final; 
Data.K.type = 'Constant';
Data.K.mean = 176299; 
Data.K.standard_deviation = [];
Data.K.autocorrelation = [];
Data = updateGuildInfo(Data);
Data = addDerivedQuantities(Data);
Data.nYearsFwd = length(tspan)- 1;
Data = compileOdeData(Data);
GuildInfo = Data.GuildInfo;
Binds = 1:GuildInfo.nGuilds;
Binit = vertcat(Data.Guilds.binit);

Binit(95)=0;

Data.year = 1;

options = odeset('AbsTol',1.000000000000000e-10,'RelTol',1.000000000000000e-08);
[~,BC]  = ode45(@(t,BC)atn_ode_massbalance_baseline(t,BC,Data,kmix), tspan, [Binit], options);

% ----------------------------------------------------------------------- %
% extinction threshold
BC(BC< 1e-06) = 0;
% ----------------------------------------------------------------------- %
    
if ~isreal(BC) || any(any(isnan(BC)))
    error('Differential eqution solver returned non real biomasses. Check model parameters.');
end

clock2 = clock;
	
clock2-clock1	
    
Before = BC;    

save('Before','Before');