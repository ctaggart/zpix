# stbz Development Instructions

## Build Commands

- `zig build` - Build the library
- `zig build test` - Run all tests
- `zig build -Doptimize=ReleaseFast` - Build optimized

## Development Approach

**Strict TDD**: Always write the test first, see it fail, then implement.

## Architecture

- `src/stbz.zig` - Main library entry point
- `src/jpeg.zig` - JPEG baseline decoder
- `src/png.zig` - PNG decoder/encoder
- `src/image.zig` - Image data structure
- `src/streaming.zig` - Low-memory streaming operations
- `src/decode_context.zig` - Shared PNG decoding context

## Testing

All Zig implementations must be compared against the C reference (stb_image).
Test fixtures are in `test/fixtures/`.

## Code Style

- Use Zig standard library conventions
- Explicit error handling
- Support custom allocators
