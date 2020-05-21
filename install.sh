#!/bin/bash

set -euo pipefail

url=https://github.com/albebaubles/EmbellishForXcode/blob/master/Embellish/scripts/Embellish.scpt
SCRIPT_DIR="${HOME}/Library/Application Scripts/com.albebaubles.EmbellishForXcode.Embellish"

mkdir -p "${SCRIPT_DIR}"
curl $url -o "${SCRIPT_DIR}/Embellish.scpt"

