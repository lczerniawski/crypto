from crypto.helpers import _rotate_left, _rotate_right
from std.testing import (
    assert_equal,
    TestSuite,
)


def test_rotate_left_zero() raises:
    assert_equal(
        _rotate_left(UInt32(0xCAFEBABE), UInt32(0)), UInt32(0xCAFEBABE)
    )


def test_rotate_left_basic() raises:
    # 0x12345678 rotated left by 4 -> 0x23456781
    assert_equal(
        _rotate_left(UInt32(0x12345678), UInt32(4)), UInt32(0x23456781)
    )


def test_rotate_left_wrap() raises:
    # 0x80000001 rotated left by 1 -> 0x00000003
    assert_equal(
        _rotate_left(UInt32(0x80000001), UInt32(1)), UInt32(0x00000003)
    )


def test_rotate_left_half() raises:
    # Rotating by 16 swaps the high/low 16-bit halves
    # 0xDEADBEEF -> 0xBEEFDEAD
    assert_equal(
        _rotate_left(UInt32(0xDEADBEEF), UInt32(16)), UInt32(0xBEEFDEAD)
    )


def test_rotate_left_31() raises:
    # 1 rotated left by 31 -> 0x80000000
    assert_equal(
        _rotate_left(UInt32(0x00000001), UInt32(31)), UInt32(0x80000000)
    )


def test_rotate_right_zero() raises:
    assert_equal(
        _rotate_right(UInt32(0xCAFEBABE), UInt32(0)), UInt32(0xCAFEBABE)
    )


def test_rotate_right_basic() raises:
    # 0x12345678 rotated right by 4 -> 0x81234567
    assert_equal(
        _rotate_right(UInt32(0x12345678), UInt32(4)), UInt32(0x81234567)
    )


def test_rotate_right_wrap() raises:
    # 0x80000001 rotated right by 1 -> 0xC0000000
    assert_equal(
        _rotate_right(UInt32(0x80000001), UInt32(1)), UInt32(0xC0000000)
    )


def test_rotate_right_half() raises:
    # Rotating by 16 swaps the high/low 16-bit halves
    # 0xDEADBEEF -> 0xBEEFDEAD
    assert_equal(
        _rotate_right(UInt32(0xDEADBEEF), UInt32(16)), UInt32(0xBEEFDEAD)
    )


def test_rotate_right_31() raises:
    # 1 rotated right by 31 -> 0x00000002
    assert_equal(
        _rotate_right(UInt32(0x00000001), UInt32(31)), UInt32(0x00000002)
    )


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
