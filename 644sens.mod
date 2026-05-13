### sensitivity model file ###
# is the same as the stochastic model, just updated such that
# 	grid price during peak hours is 20% more

set HOUR;
set SCENARIO;
set PEAK_HOURS within HOUR;

### call the parameters ###
# economic parameters
param baseLoad{HOUR};
param gridBuyPrice{HOUR};
param gridBuyPrice_sens{HOUR}; # new grid buy price for peak hours
param exportPrice{HOUR};
param solarContractCost{HOUR};
param windContractCost{HOUR};
param solarMaxBlocks{HOUR};
param windMaxBlocks{HOUR};
# variable parameters
param probability{SCENARIO} >=0, <=1; # has to be between 0 and 1
param econData{HOUR, SCENARIO};
param demand{HOUR, SCENARIO};
param solar{HOUR, SCENARIO} >=0; # availability, cannot be negative
param wind{HOUR, SCENARIO} >=0; # availability, cannot be negative

### first-stage decision factors ###
# committed blocks for solar and wind
var xS{t in HOUR} >=0, <= solarMaxBlocks[t];
var xW{t in HOUR} >=0, <= windMaxBlocks[t];

### second-stage decision factor ###
var g{HOUR, SCENARIO} >=0; # grid purchases
var e{HOUR, SCENARIO} >=0; # exports

### objective function ###
minimize totalCost_sens: 
	sum{t in HOUR} (solarContractCost[t] * xS[t] + windContractCost[t] * xW[t]) 
	+ sum{s in SCENARIO} probability[s] * sum{t in HOUR} (gridBuyPrice_sens[t] 
	* g[t,s] - exportPrice[t] * e[t,s]); # updated with the new grid buy price

### constraints ###
# energy balance
subject to energyBalance{t in HOUR, s in SCENARIO}:
	solar[t,s] * xS[t] + wind[t,s] * xW[t] + g[t,s] - e[t,s] = demand[t,s];