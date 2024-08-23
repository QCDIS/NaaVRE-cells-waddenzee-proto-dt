from dtSat import dtSat

import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--date', action='store', type=str, required=True, dest='date')


args = arg_parser.parse_args()
print(args)

id = args.id

date = args.date.replace('"','')



print(dtSat.get_date(date))

