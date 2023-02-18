#!/bin/sh

set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC_DIR="${SCRIPT_DIR}/.."

# Go to root source directory.
cd "${SRC_DIR}"

if [ -z "${NETWORK_FILE}" ] || [ ! -f "${NETWORK_FILE}" ]; then
    # Download a test network.
    NETWORK_SHA=${NETWORK_SHA:="195b450999e874d07aea2c09fd0db5eff9d4441ec1ad5a60a140fe8ea94c4f3a"}
    NETWORK_URL="https://training.lczero.org/get_network?sha=${NETWORK_SHA}"

    TMP_DIR=$(mktemp -d)
    NETWORK_FILE="${TMP_DIR}/${NETWORK_SHA}"

    curl -L "${NETWORK_URL}" --output "${NETWORK_FILE}"
fi

if [ ! -f "${NETWORK_FILE}.onnx" ]; then
    # Convert network to ONNX.
    lc0 leela2onnx --input="${NETWORK_FILE}" --output="${NETWORK_FILE}.onnx"
fi


PYTEST="python -m pytest"
TEST_NETWORK="${NETWORK_FILE}" ${PYTEST}