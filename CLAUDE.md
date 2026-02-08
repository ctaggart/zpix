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
- Prefer `*const` for read-only pointer parameters
- Use `const Self = @This()` for struct self-reference

### Variable Naming

**Use descriptive full names by default:**
```zig
// Good
const bytes_read = try reader.read(buffer);
const component_width = width * channels;
const interpolated_value = (top * weight_y + bottom * (1 - weight_y));

// Avoid
const n = try reader.read(buffer);
const cw = width * channels;
const val = (top * weight_y + bottom * (1 - weight_y));
```

**Exceptions - well-established abbreviations:**
- Loop counters in small scopes: `i`, `j`, `x`, `y`
- Coordinates: `x`, `y`, `w`, `h` (when obvious from context)
- Image processing standards: `r`, `g`, `b`, `a` (RGBA), `cb`, `cr` (chroma)
- Format-specific: `qt` (quantization table), `ht` (Huffman table), `mcu` (minimum coded unit)
- Common: `img` for Image parameter, `buf` for buffer in very short scopes

**When in doubt, prefer clarity over brevity.**

### Logging

Use scoped logging for debugging and diagnostics:

```zig
const log = std.log.scoped(.stbz_modulename);

// Use sparingly - libraries should minimize logging
log.debug("Failed to parse header: offset={}, marker=0x{X:0>4}", .{offset, marker});
log.debug("Processing component {}/{}", .{i + 1, total});
```

**Guidelines:**
- Use scoped logs with `.stbz_<modulename>` (e.g., `.stbz_jpeg`, `.stbz_png`)
- Prefer returning errors over logging in library code
- Use `log.debug()` for error context and diagnostics (only visible with debug logging enabled)
- Avoid `log.err()`, `log.info()`, and `log.warn()` in library code - let applications control logging
- Debug logs help troubleshoot issues without polluting application logs
