### metrics for expected value model file ###

# replace scenario-dependent quantities with their probability-weighted expected values
# scenario-dependent quantities: demand, solar (availability), wind (availability)
# instead of summing each scenario, use an average value included before solving
# acts as if wind and solar availability are known outputs
# will be a deterministic model

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
# added EV parameters
param demand_EV{t in HOUR} = 
	sum{s in SCENARIO} probability[s] * demand[t,s]; # includes probability
param solar_EV{t in HOUR} =
	sum{s in SCENARIO} probability[s] * solar[t,s]; # availability w/ probability
param wind_EV{t in HOUR} =
	sum{s in SCENARIO} probability[s] * wind[t,s]; # availability w/ probability

### first-stage decision factors ###
# committed blocks for solar and wind
var xS{t in HOUR} >=0, <= solarMaxBlocks[t];
var xW{t in HOUR} >=0, <= windMaxBlocks[t];

### second-stage decision factor ###
# update to EV variables
var g_EV{HOUR, SCENARIO} >=0; # expected grid purchase
var e_EV{HOUR, SCENARIO} >=0; # expected grid exports

### objective function ###
# update with new variables
minimize totalCostEV: 
	sum{t in HOUR} (solarContractCost[t] * xS[t] + windContractCost[t] * xW[t]) 
	+ sum{s in SCENARIO} probability[s] * sum{t in HOUR} (gridBuyPrice[t] 
	* g_EV[t,s] - exportPrice[t] * e_EV[t,s]);

### constraints ###
# energy balance
subject to energyBalance{t in HOUR, s in SCENARIO}:
	solar_EV[t] * xS[t] + wind_EV[t] * xW[t] + g_EV[t,s] - e_EV[t,s] = demand_EV[t];
	


