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
#warren_asset_results = pd.DataFrame()
biden_asset_results = pd.DataFrame()
sanders_asset_results = pd.DataFrame()
#pete_asset_results = pd.DataFrame()

baseline_industry_results = pd.DataFrame()
#warren_industry_results = pd.DataFrame()
biden_industry_results = pd.DataFrame()
sanders_industry_results = pd.DataFrame()
#pete_industry_results = pd.DataFrame()

#Import CSV dictionary for each candidate

baseline_parameters = csv.DictReader(open("baseline_parameters.csv"))
#warren_parameters = csv.DictReader(open("warren_parameters.csv"))
biden_parameters = csv.DictReader(open("biden_parameters.csv"))
sanders_parameters = csv.DictReader(open("sanders_parameters.csv"))
#pete_parameters = csv.DictReader(open("pete_parameters.csv"))

for cyr in range(2020,2030):

    #iterate through each year's parameters
    baseline = next(baseline_parameters)
    #warren = next(warren_parameters)
    biden = next(biden_parameters)
    sanders = next(sanders_parameters)
    #mayor_pete = next(pete_parameters)

    # Setup baseline parameters

    baseline_simulation = Specification(year=cyr)
    baseline_simulation.update_specification(baseline)
    calc1 = Calculator(baseline_simulation, assets)

    #Setup simulation parameters
    #Warren
    #warren_simulation = Specification(year=cyr)
    #warren_simulation.update_specification(warren)
    #calc_warren = Calculator(warren_simulation, assets)
    #Biden
    biden_simulation = Specification(year=cyr)
    biden_simulation.update_specification(biden)
    calc_biden = Calculator(biden_simulation, assets)
    #Sanders
    sanders_simulation = Specification(year=cyr)
    sanders_simulation.update_specification(sanders)
    calc_sanders = Calculator(sanders_simulation, assets)
    #Mayor Pete
    #pete_simulation = Specification(year=cyr)
    #pete_simulation.update_specification(mayor_pete)
    #calc_pete = Calculator(pete_simulation, assets)


    # do calculations by asset
    baseline_asset_df = calc1.calc_by_asset()
    #warren_asset_df = calc_warren.calc_by_asset()
    biden_asset_df = calc_biden.calc_by_asset()
    sanders_asset_df = calc_sanders.calc_by_asset()
    #pete_asset_df = calc_pete.calc_by_asset()

    #do calculations by industry
    baseline_industry_df = calc1.calc_by_industry()
    #warren_industry_df = calc_warren.calc_by_industry()
    biden_industry_df = calc_biden.calc_by_industry()
    sanders_industry_df = calc_sanders.calc_by_industry()
    #pete_industry_df = calc_pete.calc_by_industry()

    # generate dataframes with reform-minus-baseline differences
    #diff_assets_df = diff_two_tables(reform_assets_df, baseln_assets_df)
    #diff_industry_df = diff_two_tables(reform_industry_df, baseln_industry_df)

    #Create Year indicator
    baseline_asset_df['year'] = str(cyr)
    #warren_asset_df['year'] = str(cyr)
    biden_asset_df['year'] = str(cyr)
    sanders_asset_df['year'] = str(cyr)
    #pete_asset_df['year'] = str(cyr)

    baseline_industry_df['year'] = str(cyr)
    #warren_industry_df['year'] = str(cyr)
    biden_industry_df['year'] = str(cyr)
    sanders_industry_df['year'] = str(cyr)
    #pete_industry_df['year'] = str(cyr)

    #Write data to result dataframe
    baseline_asset_results = pd.concat([baseline_asset_results, baseline_asset_df])
    #warren_asset_results = pd.concat([warren_asset_results, warren_asset_df])
    biden_asset_results = pd.concat([biden_asset_results, biden_asset_df])
    sanders_asset_results = pd.concat([sanders_asset_results, sanders_asset_df])
    #pete_asset_results = pd.concat([pete_asset_results, pete_asset_df])

    baseline_industry_results = pd.concat([baseline_industry_results, baseline_industry_df])
    #warren_industry_results = pd.concat([warren_industry_results, warren_industry_df])
    biden_industry_results = pd.concat([biden_industry_results, biden_industry_df])
    sanders_industry_results = pd.concat([sanders_industry_results, sanders_industry_df])
    #pete_industry_results = pd.concat([pete_industry_results, pete_industry_df])


#Drop extra data in the asset data

#columns to drop
drop_columns_assets = ['bea_asset_code', 
                'minor_asset_group', 
                'tax_wedge_d', 
                'tax_wedge_e', 
                'tax_wedge_mix',
                'index',
                'delta',
                'eatr_d',
                'eatr_e',
                'eatr_mix',
                'major_asset_group',
                'rho_e',
                'rho_d',
                'rho_mix',
                'ucc_d',
                'ucc_e',
                'ucc_mix',
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
baseline_industry_results = baseline_industry_results.drop(columns=drop_columns_industry)

biden_asset_results = biden_asset_results.drop(columns=drop_columns_assets)
biden_industry_results = biden_industry_results.drop(columns=drop_columns_industry)

sanders_asset_results = sanders_asset_results.drop(columns=drop_columns_assets)
sanders_industry_results = sanders_industry_results.drop(columns=drop_columns_industry)


baseline_asset_results = baseline_asset_results[(baseline_asset_results.asset_name == 'Equipment') |
                                    (baseline_asset_results.asset_name == 'Structures') |
                                    (baseline_asset_results.asset_name == 'Intellectual Property') |
                                    (baseline_asset_results.asset_name == 'Inventories') |
                                    (baseline_asset_results.asset_name == 'Land') |
                                    (baseline_asset_results.asset_name == 'Overall')]

biden_asset_results = biden_asset_results[(biden_asset_results.asset_name == 'Equipment') |
                                    (biden_asset_results.asset_name == 'Structures') |
                                    (biden_asset_results.asset_name == 'Intellectual Property') |
                                    (biden_asset_results.asset_name == 'Inventories') |
                                    (biden_asset_results.asset_name == 'Land') |
                                    (biden_asset_results.asset_name == 'Overall')]

sanders_asset_results = sanders_asset_results[(sanders_asset_results.asset_name == 'Equipment') |
                                    (sanders_asset_results.asset_name == 'Structures') |
                                    (sanders_asset_results.asset_name == 'Intellectual Property') |
                                    (sanders_asset_results.asset_name == 'Inventories') |
                                    (sanders_asset_results.asset_name == 'Land') |
                                    (sanders_asset_results.asset_name == 'Overall')]


baseline_asset_results = baseline_asset_results.sort_values(by = sort_columns_assets)
biden_asset_results = biden_asset_results.sort_values(by = sort_columns_assets)
sanders_asset_results = sanders_asset_results.sort_values(by = sort_columns_assets)

# save dataframes to disk as csv files in this directory
baseline_industry_results.to_csv('baseline_byindustry.csv', float_format='%.5f')
#reform_industry_df.to_csv('reform_byindustry.csv', float_format='%.5f')
baseline_asset_results.to_csv('baseline_results_assets.csv', float_format='%.5f')
biden_asset_results.to_csv('biden_results_assets.csv', float_format='%.5f')
sanders_asset_results.to_csv('sanders_results_assets.csv', float_format='%.5f')
#results_industry_df.to_csv('results_industry.csv', float_format='%.5f')
#reform_assets_df.to_csv('reform_byasset.csv', float_format='%.5f')
#diff_industry_df.to_csv('changed_byindustry.csv', float_format='%.5f')
#diff_assets_df.to_csv('changed_byasset.csv', float_format='%.5f')



# create and show in browser a range plot
#p = calc1.range_plot(calc2)
#show(p)
