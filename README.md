# Crypto for Mojo

A Mojo cryptography library intended to cover the commonly used cryptographic algorithms.

> [!WARNING]
> 🚧 **Work in progress:** This library is actively being built out, and the plan is to implement all standard crypto algorithms over time.

## Overview

This repository currently includes:

- MD5, SHA-1 and SHA-256 hash implementations
- Secure random integer generation

## Current Modules

| Module          | Notes                                    |
| --------------- | ---------------------------------------- |
| `crypto.hashes` | MD5, SHA-1 and SHA-256 hashing functions |
| `crypto.random` | Secure integer generation functions      |

## Installation

crypto is available in the modular-community package repository. To install, add it to your channels in `pixi.toml`:

```toml
channels = [
    "https://conda.modular.com/max",
    "https://repo.prefix.dev/modular-community",
    "conda-forge"
]
```

Then, install using the Pixi CLI:

```bash
pixi add crypto
```

This fetches the latest version and makes it immediately available for import.

## Quick Start

### Hashing

```mojo
from crypto.hashes import md5, sha1, sha256

def main() raises:
	var md5_digest = md5("abc".as_bytes())
	var sha1_digest = sha1("abc".as_bytes())
	var sha256_digest = sha256("abc".as_bytes())

	print("MD5:", md5_digest.to_hex())
	print("SHA-1:", sha1_digest.to_hex())
	print("SHA-256:", sha256_digest.to_hex())
```

### Random Values

```mojo
from crypto.random import generate_secure_u32

def main() raises:
	var value = generate_secure_u32()
	print("Random value:", value)
```

## API Reference

### Hashes

#### `md5(data: Span[UInt8, ...]) -> MD5Digest`

Compute an MD5 digest for the given bytes.

#### `sha1(data: Span[UInt8, ...]) -> SHA1Digest`

Compute a SHA-1 digest for the given bytes.

#### `sha256(data: Span[UInt8, ...]) -> SHA256Digest`

Compute a SHA-256 digest for the given bytes.

#### `MD5Digest`

Represents a 128-bit MD5 digest.

**Methods:**

- `to_hex() -> String` - Returns the digest as a 32-character lowercase hexadecimal string
- `to_bytes() -> List[UInt8]` - Returns the digest as a list of 16 bytes (little-endian format)

**Example:**

```mojo
var digest = md5("hello".as_bytes())
print(digest.to_hex())      # "5d41402abc4b2a76b9719d911017c592"
var bytes = digest.to_bytes()  # List of 16 UInt8 values
```

#### `SHA1Digest`

Represents a 160-bit SHA-1 digest.

**Methods:**

- `to_hex() -> String` - Returns the digest as a 40-character lowercase hexadecimal string
- `to_bytes() -> List[UInt8]` - Returns the digest as a list of 20 bytes (big-endian format)

**Example:**

```mojo
var digest = sha1("hello".as_bytes())
print(digest.to_hex())      # "aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d"
var bytes = digest.to_bytes()  # List of 20 UInt8 values
```

#### `SHA256Digest`

Represents a 256-bit SHA-256 digest.

**Methods:**

- `to_hex() -> String` - Returns the digest as a 64-character lowercase hexadecimal string
- `to_bytes() -> List[UInt8]` - Returns the digest as a list of 32 bytes (big-endian format)

**Example:**

```mojo
var digest = sha256("hello".as_bytes())
print(digest.to_hex())      # "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
var bytes = digest.to_bytes()  # List of 32 UInt8 values
```

### Random

#### `generate_secure_u8()`

Generate a secure random `UInt8` value.

#### `generate_secure_u16()`

Generate a secure random `UInt16` value.

#### `generate_secure_u32()`

Generate a secure random `UInt32` value.

#### `generate_secure_u64()`

Generate a secure random `UInt64` value.

#### `generate_secure_u128()`

Generate a secure random `UInt128` value.

## Tests

Run all tests using Pixi:

```bash
pixi run test
```

Or run individual test files with Mojo:

```bash
mojo run -I src tests/<test-file>.mojo
```

## Project Layout

- `src/crypto/hashes/` - Hashing algorithms and digest types
- `src/crypto/random/` - Secure random number helpers
- `src/crypto/helpers.mojo` - Shared low-level helpers
- `tests/` - Unit tests for the available primitives

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome. Please keep changes focused, well-tested, and consistent with the existing module structure.
