#!/bin/env python3

import sys
from os.path import basename
from urllib.parse import quote

if len(sys.argv) != 2:
    print("Urlencodes given string.")
    print("Usage:")
    print(f"\t{basename(sys.argv[0])} <STRING>")
    sys.exit(1)

print(quote(sys.argv[1]))
