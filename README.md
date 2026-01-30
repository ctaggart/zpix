# stbz

A Zig port of stb_image focusing on PNG support with thumbnail and tiling capabilities.

## Features

- Pure Zig PNG decoder and encoder (no C dependencies for core functionality)
- Crop operations
- Resize operations (bilinear interpolation)
- Thumbnail generation (center crop + resize)
- CLI tool for image processing

## PNG Support

### Supported

| Feature | Decode | Encode |
|---------|--------|--------|
| RGB (8-bit) | Yes | Yes |
| RGBA (8-bit) | Yes | Yes |
| Grayscale (8-bit) | Yes | Yes |
| Grayscale+Alpha (8-bit) | Yes | Yes |
| Adam7 interlacing | Yes | No |
| All filter types (None, Sub, Up, Average, Paeth) | Yes | None only |

### Not Supported

- Palette/indexed color (color type 3)
- 16-bit depth
- 1/2/4-bit depth
- Ancillary chunks (gAMA, cHRM, sRGB, iCCP, tRNS)

## Building

```bash
zig build
```

## Testing

```bash
zig build test
```

## CLI Usage

```bash
# Crop a region from an image
stbz crop input.png output.png 100 100 200 200

# Resize an image
stbz resize input.png output.png 640 480

# Create a square thumbnail (crops to center, then resizes)
stbz thumbnail input.png thumb.png 128
```

## Library Usage

```zig
const stbz = @import("stbz");

// Load a PNG image
var image = try stbz.loadPngFile(allocator, "image.png");
defer image.deinit();

// Crop
var cropped = try image.crop(x, y, width, height);
defer cropped.deinit();

// Resize
var resized = try image.resize(new_width, new_height);
defer resized.deinit();
```

## Test Images

The test fixture `landscape_600x400.png` is a photo of Cinque Terre, Italy, sourced from W3Schools and used for testing purposes.

## License

Public domain (same as stb libraries)
