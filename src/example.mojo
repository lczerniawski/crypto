from crypto.hashes import md5, sha1, sha256
from crypto.random import generate_secure_u32, generate_secure_u64


def main() raises:
    # SHA-256 Hashing Example
    print("SHA-256 Hashing:")
    var sha256_digest = sha256("hello world".as_bytes())
    print("  Input: 'hello world'")
    print("  Hex output:", sha256_digest.to_hex())
    print()

    # MD5 Hashing Example
    print("MD5 Hashing:")
    var md5_digest = md5("hello world".as_bytes())
    print("  Input: 'hello world'")
    print("  Hex output:", md5_digest.to_hex())
    print()

    # SHA-1 Hashing Example
    print("SHA-1 Hashing:")
    var sha1_digest = sha1("hello world".as_bytes())
    print("  Input: 'hello world'")
    print("  Hex output:", sha1_digest.to_hex())
    print()

    # MD5 with different input
    print("MD5 with empty string:")
    var empty_md5 = md5("".as_bytes())
    print("  Input: ''")
    print("  Hex output:", empty_md5.to_hex())
    print()

    # SHA-1 with different input
    print("SHA-1 with longer input:")
    var long_input = "The quick brown fox jumps over the lazy dog"
    var long_sha1 = sha1(long_input.as_bytes())
    print("  Input: '" + long_input + "'")
    print("  Hex output:", long_sha1.to_hex())
    print()

    # Secure Random Generation
    print("Secure Random Values:")
    print("  Random UInt32:", generate_secure_u32())
    print("  Random UInt32:", generate_secure_u32())
    print("  Random UInt64:", generate_secure_u64())
    print("  Random UInt64:", generate_secure_u64())
