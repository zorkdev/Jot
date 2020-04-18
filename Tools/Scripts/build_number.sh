#!/usr/bin/env sh

set -euo pipefail

cd $XCS_PRIMARY_REPO_DIR/Jot
xcrun agvtool new-version -all $XCS_INTEGRATION_NUMBER
