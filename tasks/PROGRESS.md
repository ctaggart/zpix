# stbz Progress Tracker

## Current Phase: Complete

## Completed
- [x] Phase 1: Project Setup
  - [x] Project structure created
  - [x] README.md created
  - [x] CLAUDE.md created
  - [x] PROGRESS.md created
  - [x] Initialize build.zig and build.zig.zon
  - [x] Download stb headers
  - [x] Create reference implementation wrapper
  - [x] Create test fixtures (RGB and RGBA PNGs)
  - [x] Write first comparison test
- [x] Phase 2: Core Image Types
  - [x] Image struct with width, height, channels, data
  - [x] Memory management (init/deinit)
  - [x] Pixel access utilities (getPixel/setPixel)
  - [x] Clone operation
- [x] Phase 3: PNG Decoder
  - [x] PNG signature validation
  - [x] IHDR chunk parsing
  - [x] IDAT chunk parsing and zlib decompression
  - [x] Filter reconstruction (None, Sub, Up, Average, Paeth)
  - [x] Adam7 interlacing support
  - [x] Grayscale and grayscale+alpha support
  - [x] Comparison tests pass (byte-identical to stb_image)
- [x] Phase 4: Image Operations
  - [x] Crop operation with bounds checking
  - [x] Resize operation (bilinear interpolation)
- [x] Phase 5: CLI Tool
  - [x] `stbz crop` - Crop region from image
  - [x] `stbz resize` - Resize to specified dimensions
  - [x] `stbz thumbnail` - Create square thumbnail (center crop + resize)
  - [x] Pure Zig PNG encoder (saveToFile/saveToMemory)
- [x] Phase 6: JPEG Decoder
  - [x] Baseline DCT (SOF0) decoding
  - [x] Huffman and quantization table parsing
  - [x] IDCT (integer fixed-point, matching stb_image)
  - [x] YCbCr to RGB conversion
  - [x] Chroma subsampling: 4:4:4, 4:2:2, 4:2:0
  - [x] Bilinear chroma upsampling (matches stb_image)
  - [x] Grayscale JPEG support
  - [x] Restart marker (DRI) handling
  - [x] Comparison tests pass against stb_image (tolerance <= 3)

## Test Results
- 47/47 tests passing
- PNG decoder produces byte-identical output to stb_image
- JPEG decoder matches stb_image within tolerance of 1 (small images) to 3 (large images)
- Interlaced (Adam7) PNG support verified against reference
- Crop and resize operations fully tested

## Notes
- Using TDD approach throughout
- All implementations compared against C reference
- Using Zig 0.15.2 with new Io and ArrayList APIs
