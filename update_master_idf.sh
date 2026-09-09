#!/usr/bin/env bash
# Update the "master" ESP-IDF checkout to the latest origin/master.
# Separate from test_all_idf.sh because this can be slow (fetch + submodule
# update) and you don't want it re-run on every test pass.
set -u

IDF_MASTER_REPO="$HOME/.espressif/master/esp-idf"

if [ ! -d "$IDF_MASTER_REPO/.git" ]; then
  echo "ERROR: $IDF_MASTER_REPO is not a git checkout"
  exit 1
fi

echo "==> Updating esp-idf master checkout at $IDF_MASTER_REPO"
cd "$IDF_MASTER_REPO" &&
git fetch origin master &&
git reset --hard origin/master &&
git submodule update --init --recursive &&

# The python venv (idf-component-manager, esptool, etc.) is pinned to
# whatever the source tree required when it was last installed. A moving
# master branch can bump those requirements, so reinstall after every
# update or idf.py fails with stale-module errors.
echo "==> Reinstalling esp-idf python environment" &&
unset IDF_PATH &&
./install.sh
