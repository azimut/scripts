#!/bin/env python3

import sys
from os.path import basename
from urllib.parse import unquote

if len(sys.argv) != 2:
    print("Urldecodes given URL parameter.")
    print("Usage:")
    print(f"\t{basename(sys.argv[0])} <URL>")
    sys.exit(1)

print(unquote(sys.argv[1]))
