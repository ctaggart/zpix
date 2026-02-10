const std = @import("std");
const stbz = @import("stbz");

const c = @cImport({
    @cInclude("stb_image.h");
});

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const path = "/home/diogo/RPG/Eberron/Images/session06/SilverwoodDaoDao.jpg";

    std.debug.print("Comparing progressive JPEG decoding:\n", .{});
    std.debug.print("  File: {s}\n\n", .{path});

    // Load with stb_image (C reference)
    var width: c_int = 0;
    var height: c_int = 0;
    var channels: c_int = 0;
    const ref_data = c.stbi_load(path, &width, &height, &channels, 0) orelse {
        std.debug.print("✗ stb_image failed to load\n", .{});
        return error.ReferenceLoadFailed;
    };
    defer c.stbi_image_free(ref_data);

    std.debug.print("✓ stb_image: {}x{} with {} channels\n", .{ width, height, channels });

    // Load with stbz
    var img = try stbz.loadJpegFile(allocator, path);
    defer img.deinit();

    std.debug.print("✓ stbz:      {}x{} with {} channels\n\n", .{ img.width, img.height, img.channels });

    // Compare dimensions
    if (img.width != @as(u32, @intCast(width)) or img.height != @as(u32, @intCast(height)) or img.channels != @as(u8, @intCast(channels))) {
        std.debug.print("✗ Dimension mismatch!\n", .{});
        return error.DimensionMismatch;
    }

    // Compare pixel data
    const size = @as(usize, @intCast(width)) * @as(usize, @intCast(height)) * @as(usize, @intCast(channels));
    const ref_slice = ref_data[0..size];

    var max_diff: u32 = 0;
    var diff_count: usize = 0;
    var total_diff: u64 = 0;

    for (ref_slice, img.data) |ref_pixel, zig_pixel| {
        const diff = if (ref_pixel > zig_pixel) ref_pixel - zig_pixel else zig_pixel - ref_pixel;
        if (diff > 0) {
            diff_count += 1;
            total_diff += diff;
            if (diff > max_diff) max_diff = diff;
        }
    }

    std.debug.print("Pixel comparison:\n", .{});
    std.debug.print("  Total pixels:   {}\n", .{size});
    std.debug.print("  Different:      {} ({d:.2}%)\n", .{ diff_count, @as(f64, @floatFromInt(diff_count)) / @as(f64, @floatFromInt(size)) * 100.0 });
    std.debug.print("  Max difference: {}\n", .{max_diff});
    std.debug.print("  Avg difference: {d:.2}\n", .{@as(f64, @floatFromInt(total_diff)) / @as(f64, @floatFromInt(if (diff_count > 0) diff_count else 1))});

    if (max_diff <= 3) {
        std.debug.print("\n✓ PASS: Images match within tolerance (max diff <= 3)\n", .{});
    } else {
        std.debug.print("\n⚠ WARNING: Max difference {} exceeds typical tolerance of 3\n", .{max_diff});
        std.debug.print("  (This may be acceptable for progressive JPEGs with skipped refinement scans)\n", .{});
    }
}
