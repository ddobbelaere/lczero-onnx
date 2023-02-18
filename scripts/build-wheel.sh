#!/bin/sh

set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC_DIR="${SCRIPT_DIR}/.."

# Go to root source directory.
cd "${SRC_DIR}"

# Build wheel.
pip install --upgrade build
python -m build