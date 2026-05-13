# tamu-engy644

ENGY 644 Final Project              # project report file    

data file directory/       
├── Demand_MWh_By_Scenario.csv              
├── Hourly_Economic_Data.csv       
├── Quick_Stats.csv        
├── Scenario_Summary.csv         
├── Solar_CF_By_Scenario.csv       
└── Wind_CF_By_Scenario.csv    

ampl file directory/     
├── 644run.run                      # AMPL script to load everything      
├── 644data.run                     # combined data file     
├── models/     
│   ├── 644stochastic.mod  		      # stochastic model file    
│   ├── 644deterministic.mod        # deterministic model for WS     
│   ├── 644metrics.mod		          # metrics for EV    
│   └── 644scens.mod		            # sensitivity analysis 
└── 644_AMPL_results.csv            # visualization of AMPL results in Microsoft Excel    

python file directory/  
└── ssw_engy644finalproject.ipynb    
