#!/usr/bin/env python3

import os

import numpy as np
import onnxruntime as ort
import pytest
from lczero.backends import Backend, GameState, Weights


def bitboard_to_numpy(bitboard: int) -> np.ndarray:
    """
    Convert a bitboard (64 bits) to a numpy data array of dimension 8x8.
    """

    return np.array([(bitboard >> i) & 1 for i in range(64)]).reshape((8, 8))


def test_bitboard_to_numpy():
    """
    Test function bitboard_to_numpy().
    """
    assert np.array_equal(bitboard_to_numpy(0), np.zeros((8, 8)))
    assert np.array_equal(bitboard_to_numpy(0xFFFFFFFFFFFFFFFF), np.ones((8, 8)))
    assert np.array_equal(
        bitboard_to_numpy(0xFFFFFFFFFFFF00FF),
        np.array([np.zeros(8) if i == 1 else np.ones(8) for i in range(8)]),
    )


def test_lc0_onnxruntime_equivalence():
    """
    Test if lc0 backend yields the same eval as onnxruntime.
    """
    # First get eval using lc0 backend.
    weights_file = os.environ["TEST_NETWORK2"]
    onnx_file = f"{weights_file}.onnx"

    w = Weights(weights_file)
    b = Backend(weights=w)

    g = GameState(moves=["g2g4"])

    input = g.as_input(b)
    (output,) = b.evaluate(input)
    draw_prob_lc0 = output.d()

    # Next try the onnx runtime.
    planes = np.array(
        [[bitboard_to_numpy(input.mask(i)) for i in range(112)]], dtype=np.float32
    )

    ort_sess = ort.InferenceSession(onnx_file)
    (output_onnx,) = ort_sess.run(["/output/wdl"], {"/input/planes": planes})[0]
    draw_prob_onnx = output_onnx[1]

    assert draw_prob_lc0 == pytest.approx(draw_prob_onnx, rel=1e-2)
