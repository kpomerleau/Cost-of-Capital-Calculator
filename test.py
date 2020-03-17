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

baseline_parameters = csv.DictReader(open("baseline_parameters.csv"))

#for cyr in range(0,9):

baseline = next(baseline_parameters)

baseline_parameters = Specification(year=2020)
baseline_parameters.update_specification(baseline)
calc1 = Calculator(baseline_parameters, assets)
baseline_asset_df = calc1.calc_by_asset()
baseline_asset_df.to_csv('test.csv', float_format='%.5f')