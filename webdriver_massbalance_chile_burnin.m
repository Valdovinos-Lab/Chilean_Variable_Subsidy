%Use the Data file planton_foodweb and plankton_offshore
load Data\ChileanIntertidal_ECIMBiomass_massbalance5.mat 
load Data\steadystate3850_corrected.mat

year = 2003;
kmix = 1;

t_init = 0;
t_final = 365*24*10; %(Should run to 365*24 for actual runs.)
tspan = t_init:t_final;

Data = updateGuildInfo(Data);
Data = addDerivedQuantities(Data);

Data.nYearsFwd = length(tspan)- 1;
Data = compileOdeData(Data);
GuildInfo = Data.GuildInfo;
Binds = 1:GuildInfo.nGuilds;
Binit = steadystate3850_corrected';

%Import the fluorescence file
[time,fluo] = fluoimport_daily(year);

n = length(time);
time(n) = [];
fluo(n) = [];
n = n-1;

for i = 0:9
    for j = 1:n
        time(i*n+j) = time(j)+365*24*i;
    end
end

fluo = [fluo;fluo;fluo;fluo;fluo;fluo;fluo;fluo;fluo;fluo];

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