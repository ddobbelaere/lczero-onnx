# Leela Chess Zero ONNX tools

## Setup environment

Make sure that you have a recent C++ compiler (e.g. `g++`) and a Python version installed which is supported by the package [`onnxruntime`](https://github.com/microsoft/onnxruntime).

The following script sets up the environment into the folder `DEST_DIR` (by default equal to the current directory). The optional environment variable `PYTHON` (by default `$(command -v python)`) can be used to change the Python version.

```bash
DEST_DIR=build PYTHON=python3.10 ./scripts/setup.sh
```

It does the following things:
- Create a Python virtual environment `DEST_DIR/venv` with all the necessary packages (e.g. `onnxruntime`) installed.
- Build and install the `lc0` python bindings (for the latest `lc0` release version) into the folder `DEST_DIR/lczero`.

## Example usage

```bash
$ cd ${DEST_DIR} 
$ . venv/bin/activate
(venv) $ python
>> import lczero.backends
>> import onnxruntime
```