#!/bin/bash

set -euo pipefail && url="https://albebaubles.com/wp-content/uploads/2020/09/Embellish.txt" && SCRIPT_DIR="${HOME}/Library/Application Scripts/com.albebaubles.EmbellishForXcode" && mkdir -p "${SCRIPT_DIR}" && curl $url -o "${SCRIPT_DIR}/Embellish.scpt"

