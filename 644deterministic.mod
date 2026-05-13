### deterministic model file ###

# use to solve wait-and-see benchmark
# solve model for each scenario as if it was known in advance
# essentially, there will be no probability in the objective function

set HOUR;
set SCENARIO;

### call the parameters ###
# economic parameters
param baseLoad{HOUR};
param gridBuyPrice{HOUR};
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

# add a scenario for this deterministic model
param SCEN symbolic in SCENARIO; # will replace "s" for scenario in the energy balance

### first-stage decision factors ###
# committed blocks for solar and wind
var xS{t in HOUR} >=0, <= solarMaxBlocks[t];
var xW{t in HOUR} >=0, <= windMaxBlocks[t];

### second-stage decision factor ###
# not probability based
var g_WS{t in HOUR} >=0; # grid purchases, only time-based
var e_WS{t in HOUR} >=0; # exports, only time-based

### objective function ###
minimize totalCostWS: 
	sum{t in HOUR} (solarContractCost[t] * xS[t] + windContractCost[t] * xW[t]) 
	+ sum{t in HOUR} (gridBuyPrice[t] 
	* g_WS[t] - exportPrice[t] * e_WS[t]);

### constraints ###
# energy balance
subject to energyBalance{t in HOUR, s in SCENARIO}:
	solar[t,SCEN] * xS[t] + wind[t,SCEN] * xW[t] + g_WS[t] - e_WS[t] = demand[t,SCEN];