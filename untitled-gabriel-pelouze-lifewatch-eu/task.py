
import argparse
import json
import os
arg_parser = argparse.ArgumentParser()


arg_parser.add_argument('--id', action='store', type=str, required=True, dest='id')


arg_parser.add_argument('--b', action='store', type=int, required=True, dest='b')


args = arg_parser.parse_args()
print(args)

id = args.id

b = args.b



print(b)

