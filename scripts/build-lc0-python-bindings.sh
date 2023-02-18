#!/bin/sh
# This script builds the lc0 python bindings.

set -e

# Define installation directory.
INSTALL_DIR=${INSTALL_DIR:="."}
mkdir -p "${INSTALL_DIR}"

INSTALL_DIR=$(CDPATH= cd -- "${INSTALL_DIR}" && pwd)

# Work in a temporary folder.
TMP_DIR=$(mktemp -d)
cd "${TMP_DIR}"

if false; then
    # Clone the lc0 repository and checkout the latest release branch.
    git clone --recurse-submodules https://github.com/LeelaChessZero/lc0.git
    cd lc0

    LATEST_RELEASE_BRANCH=$(git branch -r -l 'origin/release/*' | sort -r | head -n 1 | awk '{$1=$1};1')
    git checkout "${LATEST_RELEASE_BRANCH}"
else
    # Temporarily use a patched lc0 until fixes are in upstream repository.
    git clone --recurse-submodules https://github.com/ddobbelaere/lc0.git
    cd lc0

    git checkout "origin/bugfix/ninja-detection"
fi

# Install build dependencies.
pip install -U meson ninja

./build.sh -Dpython_bindings=true


# Copy artifacts to installation directory.
cp build/release/lc0 "${INSTALL_DIR}"
cp build/release/*cpython*.so "${INSTALL_DIR}"

# Remove temporary directory.
rm -rf "${TMP_DIR}"