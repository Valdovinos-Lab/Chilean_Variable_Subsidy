%Use the Data file planton_foodweb and plankton_offshore
load Data\ChileanIntertidal_ECIMBiomass_massbalance4.mat 
load Data\steadystate3850.mat

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
Binit = steadystate3850';

Binit(107) = 0; %%DELETE ME TO WORK

%Import the fluorescence file

%Import fluorescence data for (year), and use the final value from (year-1)
%as initial value
%initial value for
%99: 2.83372247        , 00: 2.597674667       , 01: 0.038666667
%02: 3.683             , 03: fine starts at t=1, 04: 2.031
%05: fine starts at t=1, 06: 1.300333333       , 07: 7.856
%08: 3.899333333       , 09: 0.403             , 10: 0.318

[time,fluo] = fluoimport_daily(2004, 2.031);

%Scale up the fluo so that average of fluo is equal to the original
%subsidies

% AVERAGE OVER ALL YEARS
% California mean = 0.719133546930636
% Chile mean = 1.567

scale = 0.12*61291/1.567;
fluo = scale*fluo;
fluo_spline = spline(time,fluo);
fluo_deriv = fnder(fluo_spline, 1);

Binit(108) = fluo(1);
Data.year = 1;

options = odeset('AbsTol',1.000000000000000e-10,'RelTol',1.000000000000000e-08);
[~,BC]  = ode45(@(t,BC)atn_ode_massbalance(t,BC,Data,fluo_deriv,kmix), tspan, [Binit], options);

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