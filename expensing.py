"""
Runs Cost-of-Capital-Calculator with TCJA as baseline and 2017 law as reform
----------------------------------------------------------------------------
"""
# import support packages and Cost-of-Capital-Calculator classes and function
from bokeh.io import show
import taxcalc
from ccc.data import Assets
from ccc.parameters import Specification
from ccc.calculator import Calculator
from ccc.utils import diff_two_tables
import pandas as pd
import csv

# specify individual income and business tax reform to compare against
# ... Note that TCJA is current-law baseline in Tax-Calculator,
#     so to compare TCJA to 2017 law, we'll use 2017 law as the reform
#reform_url = ('https://raw.githubusercontent.com/'
#              'PSLmodels/Tax-Calculator/master/taxcalc/'
#              'reforms/2017_law.json')
#iit_reform = taxcalc.Policy.read_json_reform(reform_url)
# ... specify reform that implements pre-TCJA business tax policy

assets = Assets()

#create blank results dataframes
baseline_asset_results = pd.DataFrame()
expensing_asset_results = pd.DataFrame()

#Import CSV dictionary for each candidate

baseline_parameters = csv.DictReader(open("baseline_parameters.csv"))
expensing_parameters = csv.DictReader(open("expensing_parameters.csv"))

for cyr in range(2020,2030):

    #iterate through each year's parameters
    baseline = next(baseline_parameters)
    expensing = next(expensing_parameters)

    # Setup baseline parameters

    baseline_simulation = Specification(year=cyr)
    baseline_simulation.update_specification(baseline)
    calc1 = Calculator(baseline_simulation, assets)

    #expensing parameters
    expensing_simulation = Specification(year=cyr)
    expensing_simulation.update_specification(expensing)
    calc_expensing = Calculator(expensing_simulation, assets)

    # do calculations by asset
    baseline_asset_df = calc1.calc_by_asset()
    expensing_asset_df = calc_expensing.calc_by_asset()
    
    #Create Year indicator

    #Assets
    baseline_asset_df['year'] = str(cyr)
    expensing_asset_df['year'] = str(cyr)
  
    #Write data to result dataframe
    baseline_asset_results = pd.concat([baseline_asset_results, baseline_asset_df])
    expensing_asset_results = pd.concat([expensing_asset_results, expensing_asset_df])
    

#Drop extra data in the asset data

#columns to drop
drop_columns_assets = ['bea_asset_code', 
                'minor_asset_group', 
                'tax_wedge_d', 
                'tax_wedge_e', 
                'tax_wedge_mix',
                'index',
                #'delta',
                'eatr_d',
                'eatr_e',
                'eatr_mix',
                'major_asset_group',
                'rho_e',
                'rho_d',
                'rho_mix',
                #'ucc_d',
                #'ucc_e',
                #'ucc_mix',
                'z_d',
                'z_e'
                ]

drop_columns_industry = ['tax_wedge_d', 
                'tax_wedge_e', 
                'tax_wedge_mix',
                'index',
                'delta',
                'eatr_d',
                'eatr_e',
                'eatr_mix',
                'rho_e',
                'rho_d',
                'rho_mix',
                'ucc_d',
                'ucc_e',
                'ucc_mix',
                'z_d',
                'z_e'
                ]

sort_columns_assets = ['tax_treat', 'asset_name', 'year']

baseline_asset_results = baseline_asset_results.drop(columns=drop_columns_assets)
expensing_asset_results = expensing_asset_results.drop(columns=drop_columns_assets)


baseline_asset_results = baseline_asset_results[(baseline_asset_results.asset_name == 'Equipment') |
                                    (baseline_asset_results.asset_name == 'Structures') |
                                    (baseline_asset_results.asset_name == 'Intellectual Property') |
                                    (baseline_asset_results.asset_name == 'Inventories') |
                                    (baseline_asset_results.asset_name == 'Land') |
                                    (baseline_asset_results.asset_name == 'Overall')]

expensing_asset_results = expensing_asset_results[(expensing_asset_results.asset_name == 'Equipment') |
                                    (expensing_asset_results.asset_name == 'Structures') |
                                    (expensing_asset_results.asset_name == 'Intellectual Property') |
                                    (expensing_asset_results.asset_name == 'Inventories') |
                                    (expensing_asset_results.asset_name == 'Land') |
                                    (expensing_asset_results.asset_name == 'Overall')]


baseline_asset_results = baseline_asset_results.sort_values(by = sort_columns_assets)
expensing_asset_results = expensing_asset_results.sort_values(by = sort_columns_assets)

# save dataframes to disk as csv files in this directory
baseline_asset_results.to_csv('baseline_results_assets.csv', float_format='%.5f')
expensing_asset_results.to_csv('expensing_results_assets.csv', float_format='%.5f')

#results_industry_df.to_csv('results_industry.csv', float_format='%.5f')
#reform_assets_df.to_csv('reform_byasset.csv', float_format='%.5f')
#diff_industry_df.to_csv('changed_byindustry.csv', float_format='%.5f')
#diff_assets_df.to_csv('changed_byasset.csv', float_format='%.5f')



# create and show in browser a range plot
#p = calc1.range_plot(calc2)
#show(p)
