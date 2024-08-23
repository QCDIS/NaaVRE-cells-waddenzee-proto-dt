
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')



args = arg_parser.parse_args()
print(args)

id = args.id




date = '2024-08-19'

file_date = open("/tmp/date_" + id + ".json", "w")
file_date.write(json.dumps(date))
file_date.close()
