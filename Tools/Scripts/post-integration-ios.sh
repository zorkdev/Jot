#!/usr/bin/env sh

set -euo pipefail

cd $XCS_PRIMARY_REPO_DIR
sh Tools/Scripts/analyze.sh iOS
sh Tools/Scripts/upload.sh
