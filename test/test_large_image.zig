const std = @import("std");
const stbz = @import("stbz");

/// Test streaming operations with large images
/// Run with: zig build test-large
/// Requires: /tmp/large_test.png (create with: convert -size 4000x3000 plasma: PNG24:/tmp/large_test.png)
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const path = "/tmp/large_test.png";

    // Check if test image exists
    std.fs.cwd().access(path, .{}) catch {
        std.debug.print("Test image not found: {s}\n", .{path});
        std.debug.print("Create it with: convert -size 4000x3000 plasma: PNG24:{s}\n", .{path});
        return error.TestImageNotFound;
    };

    std.debug.print("Test 1: Regular crop (full image in memory)\n", .{});
    {
        var img = try stbz.loadPngFile(allocator, path);
        defer img.deinit();
        std.debug.print("  Loaded: {}x{} ({} bytes)\n", .{ img.width, img.height, img.data.len });

        var cropped = try img.crop(1000, 1000, 500, 500);
        defer cropped.deinit();
        std.debug.print("  Cropped: {}x{}\n", .{ cropped.width, cropped.height });

        try stbz.savePngFile(&cropped, "/tmp/large_crop_regular.png");
        std.debug.print("  Saved to /tmp/large_crop_regular.png\n", .{});
    }

    std.debug.print("\nTest 2: Streaming crop (row-by-row)\n", .{});
    {
        const in_file = try std.fs.cwd().openFile(path, .{});
        defer in_file.close();
        var in_buf: [8192]u8 = undefined;
        var file_reader = in_file.reader(&in_buf);

        const out_file = try std.fs.cwd().createFile("/tmp/large_crop_streaming.png", .{});
        defer out_file.close();
        var out_buf: [8192]u8 = undefined;
        var file_writer = out_file.writer(&out_buf);

        try stbz.streamingCrop(allocator, &file_reader.interface, &file_writer.interface, 1000, 1000, 500, 500);
        std.debug.print("  Saved to /tmp/large_crop_streaming.png\n", .{});
    }

    std.debug.print("\nTest 3: Streaming resize\n", .{});
    {
        const in_file = try std.fs.cwd().openFile(path, .{});
        defer in_file.close();
        var in_buf: [8192]u8 = undefined;
        var file_reader = in_file.reader(&in_buf);

        const out_file = try std.fs.cwd().createFile("/tmp/large_resize_streaming.png", .{});
        defer out_file.close();
        var out_buf: [8192]u8 = undefined;
        var file_writer = out_file.writer(&out_buf);

        try stbz.streamingResize(allocator, &file_reader.interface, &file_writer.interface, 800, 600);
        std.debug.print("  Saved to /tmp/large_resize_streaming.png\n", .{});
    }

    std.debug.print("\nTest 4: Streaming thumbnail\n", .{});
    {
        const in_file = try std.fs.cwd().openFile(path, .{});
        defer in_file.close();
        var in_buf: [8192]u8 = undefined;
        var file_reader = in_file.reader(&in_buf);

        const out_file = try std.fs.cwd().createFile("/tmp/large_thumbnail.png", .{});
        defer out_file.close();
        var out_buf: [8192]u8 = undefined;
        var file_writer = out_file.writer(&out_buf);

        try stbz.streamingThumbnail(allocator, &file_reader.interface, &file_writer.interface, 256);
        std.debug.print("  Saved to /tmp/large_thumbnail.png\n", .{});
    }

    std.debug.print("\nVerifying outputs...\n", .{});
    {
        var crop1 = try stbz.loadPngFile(allocator, "/tmp/large_crop_regular.png");
        defer crop1.deinit();
        std.debug.print("  Regular crop: {}x{}\n", .{ crop1.width, crop1.height });

        var crop2 = try stbz.loadPngFile(allocator, "/tmp/large_crop_streaming.png");
        defer crop2.deinit();
        std.debug.print("  Streaming crop: {}x{}\n", .{ crop2.width, crop2.height });

        var resized = try stbz.loadPngFile(allocator, "/tmp/large_resize_streaming.png");
        defer resized.deinit();
        std.debug.print("  Streaming resize: {}x{}\n", .{ resized.width, resized.height });

        var thumb = try stbz.loadPngFile(allocator, "/tmp/large_thumbnail.png");
        defer thumb.deinit();
        std.debug.print("  Thumbnail: {}x{}\n", .{ thumb.width, thumb.height });

        if (std.mem.eql(u8, crop1.data, crop2.data)) {
            std.debug.print("\n  Crop outputs are IDENTICAL\n", .{});
        } else {
            std.debug.print("\n  WARNING: Crop outputs differ!\n", .{});
            return error.OutputMismatch;
        }
    }

    std.debug.print("\nAll tests passed!\n", .{});
}
