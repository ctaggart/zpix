# stbz

A Zig port of stb_image focusing on PNG support with thumbnail and tiling capabilities.

## Features

- PNG decoding (RGB and RGBA, 8-bit per channel)
- Crop operations
- Resize operations (bilinear interpolation)
- Thumbnail generation (center crop + resize)
- CLI tool for image processing

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
