## Testing
- are the tests relevant
- do the integration test test behavior
- can I run it with zig build integration-test (or similar name)

## Progressive JPEG Support (Partially Implemented)

### ✓ Implemented (Phase 1 & 3)
- SOF2 marker parsing (progressive JPEG detection)
- Coefficient buffer allocation and management
- DC first scan decoding (spec_start=0, spec_end=0, succ_high=0)
- AC first scan decoding (spec_start>0, succ_high=0) for interleaved components
- Finalization: dequantize + IDCT all blocks after EOI marker
- Multi-scan support (continue parsing after SOS, finalize at EOI)
- Memory cleanup on error (no leaks)

### ✗ Not Yet Implemented (Phase 2, 4, 5)
- DC refinement scans (succ_high > 0, currently skipped)
- AC refinement scans (succ_high > 0, not implemented)
- Non-interleaved AC scans (one component per scan, causes Huffman decode errors)
- Restart marker handling in progressive mode (DC predictor + EOB run reset)
- Full validation of progressive scan parameters (Ss/Se/Ah/Al ranges)

### Known Limitations
- Progressive JPEGs with refinement scans are skipped (no error, but lower quality)
- Progressive JPEGs with non-interleaved AC scans fail with HuffmanDecodeFailed
- Most real-world progressive JPEGs use non-interleaved AC scans

### Next Steps to Complete
1. Track which components are in each scan (from SOS marker)
2. Modify decodeScanProgressive to process only specified components
3. Implement DC refinement in decodeBlockProgDc (read 1 bit, add to coeff[0])
4. Implement AC refinement in decodeBlockProgAc (complex "skip zeros while refining non-zeros")
5. Test with various progressive JPEG files (4:2:0, 4:2:2, 4:4:4, grayscale)
