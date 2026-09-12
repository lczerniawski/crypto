from ...helpers import _rotate_right, _to_hex

comptime _k: SIMD[DType.uint32, 64] = [
    0x428A2F98,
    0x71374491,
    0xB5C0FBCF,
    0xE9B5DBA5,
    0x3956C25B,
    0x59F111F1,
    0x923F82A4,
    0xAB1C5ED5,
    0xD807AA98,
    0x12835B01,
    0x243185BE,
    0x550C7DC3,
    0x72BE5D74,
    0x80DEB1FE,
    0x9BDC06A7,
    0xC19BF174,
    0xE49B69C1,
    0xEFBE4786,
    0x0FC19DC6,
    0x240CA1CC,
    0x2DE92C6F,
    0x4A7484AA,
    0x5CB0A9DC,
    0x76F988DA,
    0x983E5152,
    0xA831C66D,
    0xB00327C8,
    0xBF597FC7,
    0xC6E00BF3,
    0xD5A79147,
    0x06CA6351,
    0x14292967,
    0x27B70A85,
    0x2E1B2138,
    0x4D2C6DFC,
    0x53380D13,
    0x650A7354,
    0x766A0ABB,
    0x81C2C92E,
    0x92722C85,
    0xA2BFE8A1,
    0xA81A664B,
    0xC24B8B70,
    0xC76C51A3,
    0xD192E819,
    0xD6990624,
    0xF40E3585,
    0x106AA070,
    0x19A4C116,
    0x1E376C08,
    0x2748774C,
    0x34B0BCB5,
    0x391C0CB3,
    0x4ED8AA4A,
    0x5B9CCA4F,
    0x682E6FF3,
    0x748F82EE,
    0x78A5636F,
    0x84C87814,
    0x8CC70208,
    0x90BEFFFA,
    0xA4506CEB,
    0xBEF9A3F7,
    0xC67178F2,
]


@always_inline
def _ch(x: UInt32, y: UInt32, z: UInt32) -> UInt32:
    return (x & y) ^ (~x & z)


@always_inline
def _maj(x: UInt32, y: UInt32, z: UInt32) -> UInt32:
    return (x & y) ^ (x & z) ^ (y & z)


@always_inline
def _sigma0(x: UInt32) -> UInt32:
    return _rotate_right(x, 2) ^ _rotate_right(x, 13) ^ _rotate_right(x, 22)


@always_inline
def _sigma1(x: UInt32) -> UInt32:
    return _rotate_right(x, 6) ^ _rotate_right(x, 11) ^ _rotate_right(x, 25)


@always_inline
def _gamma0(x: UInt32) -> UInt32:
    return _rotate_right(x, 7) ^ _rotate_right(x, 18) ^ (x >> 3)


@always_inline
def _gamma1(x: UInt32) -> UInt32:
    return _rotate_right(x, 17) ^ _rotate_right(x, 19) ^ (x >> 10)


def sha256(data: Span[UInt8, ...]) -> SHA256Digest:
    """
    Compute the SHA-256 digest of the given data.

    SHA-256 is a cryptographic hash function that produces a 256-bit (32-byte)
    hash value. It is part of the SHA-2 family and is widely used for
    cryptographic applications including digital signatures, message authentication,
    and data integrity verification.

    Args:
        data: Input bytes to hash.

    Returns:
        SHA256Digest: A 256-bit (32-byte) digest object with methods to access
        the result as raw bytes or a hex string.
    """

    var zero_bytes_padding = (56 - (len(data) + 1)) % 64

    var message = List[UInt8]()
    for i in range(len(data)):
        message.append(data[i])

    # Pad input data with 1 and 0s
    message.append(0x80)
    for _ in range(zero_bytes_padding):
        message.append(0x00)

    # Write original data length to last 8 bytes
    var original_message_bit_length = UInt64(len(data)) * 8
    message.append((UInt8(original_message_bit_length >> 56) & 0xFF))
    message.append((UInt8(original_message_bit_length >> 48) & 0xFF))
    message.append((UInt8(original_message_bit_length >> 40) & 0xFF))
    message.append((UInt8(original_message_bit_length >> 32) & 0xFF))
    message.append((UInt8(original_message_bit_length >> 24) & 0xFF))
    message.append((UInt8(original_message_bit_length >> 16) & 0xFF))
    message.append((UInt8(original_message_bit_length >> 8) & 0xFF))
    message.append(UInt8(original_message_bit_length & 0xFF))

    var h0: UInt32 = 0x6A09E667
    var h1: UInt32 = 0xBB67AE85
    var h2: UInt32 = 0x3C6EF372
    var h3: UInt32 = 0xA54FF53A
    var h4: UInt32 = 0x510E527F
    var h5: UInt32 = 0x9B05688C
    var h6: UInt32 = 0x1F83D9AB
    var h7: UInt32 = 0x5BE0CD19

    var n = 0
    while n < len(message):
        var w = List[UInt32]()
        for j in range(16):
            var base = n + (j * 4)
            var word = UInt32(message[base]) << 24
            word |= UInt32(message[base + 1]) << 16
            word |= UInt32(message[base + 2]) << 8
            word |= UInt32(message[base + 3])
            w.append(word)

        for t in range(16, 64):
            var x = (
                _gamma1(w[t - 2]) + w[t - 7] + _gamma0(w[t - 15]) + w[t - 16]
            )
            w.append(x)

        var a = h0
        var b = h1
        var c = h2
        var d = h3
        var e = h4
        var f = h5
        var g = h6
        var h = h7

        for t in range(64):
            var sigma1 = _sigma1(e)
            var ch = _ch(e, f, g)
            var temp1 = h + sigma1 + ch + _k[t] + w[t]
            var sigma0 = _sigma0(a)
            var maj = _maj(a, b, c)
            var temp2 = sigma0 + maj

            h = g
            g = f
            f = e
            e = d + temp1
            d = c
            c = b
            b = a
            a = temp1 + temp2

        h0 += a
        h1 += b
        h2 += c
        h3 += d
        h4 += e
        h5 += f
        h6 += g
        h7 += h

        n += 64

    return SHA256Digest(h0, h1, h2, h3, h4, h5, h6, h7)


@fieldwise_init
struct SHA256Digest:
    """
    SHA-256 hash digest.

    Represents a 256-bit SHA-256 digest, stored internally as eight 32-bit state
    words. Use `to_bytes()` to export the digest as a 32-byte big-endian list
    or `to_hex()` to get a 64-character lowercase hexadecimal string.
    """

    var h0: UInt32
    var h1: UInt32
    var h2: UInt32
    var h3: UInt32
    var h4: UInt32
    var h5: UInt32
    var h6: UInt32
    var h7: UInt32

    def to_bytes(self) -> List[UInt8]:
        """
        Export the digest as a list of 32 bytes.

        Returns:
            List[UInt8]: The 32-byte SHA-256 digest in big-endian byte order
            (standard SHA-256 output format).
        """
        var out = List[UInt8](capacity=32)

        for h in [
            self.h0,
            self.h1,
            self.h2,
            self.h3,
            self.h4,
            self.h5,
            self.h6,
            self.h7,
        ]:
            out.append(UInt8((h >> 24) & 0xFF))
            out.append(UInt8((h >> 16) & 0xFF))
            out.append(UInt8((h >> 8) & 0xFF))
            out.append(UInt8(h & 0xFF))

        return out^

    def to_hex(self) -> String:
        """
        Export the digest as a lowercase hexadecimal string.

        Returns:
            String: A 64-character lowercase hex string representation of the digest.
        """
        var bytes = self.to_bytes()
        return _to_hex(bytes)
