#!/bin/sh
# This script sets up the environment.

set -e

# Define some directory names.
DEST_DIR=${DEST_DIR:="."}
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC_DIR="${SCRIPT_DIR}/.."

# Create destination directory, if it does not exist.
mkdir -p "${DEST_DIR}"

# Move to destination directory.
cd "${DEST_DIR}"

# Create a virtual environment.
PYTHON=${PYTHON:=$(command -v python)}
"${PYTHON}" -m venv venv
. venv/bin/activate

# Build the lc0 python bindings.
INSTALL_DIR=lczero "${SCRIPT_DIR}/build-lc0-python-bindings.sh"
touch lczero/__init__.py

# Move lc0 binary to bin directory.
mkdir bin
mv lczero/lc0 bin

# Install required packages.
pip install -U pip
pip install -U -r "${SRC_DIR}/requirements.txt"