#!/usr/bin/env python3

import sys
from base64 import b64encode

import json
result = {}

with open(sys.argv[1], "rb") as f:
    result["image"] = b64encode(f.read()).decode('ascii')

print(json.dumps({"value":result}))
