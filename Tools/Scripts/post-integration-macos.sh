#!/usr/bin/env sh

set -euo pipefail

cd $XCS_PRIMARY_REPO_DIR
sh Tools/Scripts/analyze.sh macOS
sh Tools/Scripts/notarization.sh
