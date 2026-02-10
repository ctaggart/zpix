## Testing
- are the tests relevant
- do the integration test test behavior
- can I run it with zig build integration-test (or similar name)

## Progressive JPEG Support (Partially Implemented)

### ✓ Implemented (Phase 1, 3 & partial 2/4)
- SOF2 marker parsing (progressive JPEG detection)
- Coefficient buffer allocation and management
- DC first scan decoding (spec_start=0, spec_end=0, succ_high=0)
- AC first scan decoding (spec_start>0, succ_high=0) for both interleaved and non-interleaved
- **Non-interleaved AC scan support** (one component per scan)
- Component tracking per scan (which components are in each SOS)
- Finalization: dequantize + IDCT all blocks after EOI marker
- Multi-scan support (continue parsing after SOS, finalize at EOI)
- Memory cleanup on error (no leaks)
- Restart marker handling (DC predictor + EOB run reset)

### ✗ Not Yet Implemented (Phase 2, 4, 5)
- DC refinement scans (succ_high > 0, currently skipped - lower quality)
- AC refinement scans (succ_high > 0, currently skipped - lower quality)
- Full validation of progressive scan parameters (Ss/Se/Ah/Al ranges)

### Known Limitations
- **Refinement scans are skipped**: Images load but with reduced quality
  - Refinement scans add precision bits (successive approximation)
  - Without them, coefficients are less precise, resulting in lower image quality
  - Max pixel difference can be significant (e.g., 84 vs typical 3 for baseline)
- This is acceptable for viewing but not for pixel-perfect reproduction

### Image Quality Impact
- **Baseline JPEG**: Pixel-perfect match with stb_image (max diff ≤ 3)
- **Progressive JPEG** (with skipped refinement):
  - Dimensions correct ✓
  - Image recognizable ✓
  - Quality reduced (avg diff ~5, max diff can be 50-100)
  - Acceptable for display, not for pixel-perfect comparison

### Next Steps to Complete Full Quality
1. Implement DC refinement in decodeBlockProgDc (read 1 bit, add to coeff[0] at bit position Al)
2. Implement AC refinement in decodeBlockProgAc (complex: skip zeros while refining non-zeros)
   - Requires tracking which coefficients are non-zero
   - For each symbol: refine existing non-zeros OR count toward run of new zeros
3. Test with various progressive JPEG files (4:2:0, 4:2:2, 4:4:4, grayscale)
