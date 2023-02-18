#!/bin/sh
# This script builds the lc0 python bindings.

set -e
set -x

# Define installation directory.
INSTALL_DIR=${INSTALL_DIR:="."}
mkdir -p "${INSTALL_DIR}"

INSTALL_DIR=$(CDPATH= cd -- "${INSTALL_DIR}" && pwd)

# Work in a temporary folder.
TMP_DIR=$(mktemp -d)
cd "${TMP_DIR}"

# Clone the lc0 repository and checkout the latest release branch.
git clone --recurse-submodules https://github.com/LeelaChessZero/lc0.git
cd lc0

LATEST_RELEASE_BRANCH=$(git branch -r -l 'origin/release/*' | sort -r | head -n 1 | awk '{$1=$1};1')
git checkout "${LATEST_RELEASE_BRANCH}"

# Install build dependencies.
pip install -U meson ninja

./build.sh -Dpython_bindings=true

# Debug why ninja does not run.
cat build/release/meson-logs/meson-log.txt
NINJA=$(awk '/ninja/ {ninja=$4} END {print ninja}' build/release/meson-logs/meson-log.txt)
echo ${NINJA}
NINJA=$(awk '/Found.*ninja/ {ninja=$4} END {print ninja}' build/release/meson-logs/meson-log.txt)
echo ${NINJA}


# Copy artifacts to installation directory.
cp build/release/*cpython*.so "${INSTALL_DIR}"

# Remove temporary directory.
rm -rf "${TMP_DIR}"