const std = @import("std");
const stbz = @import("stbz");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const path = "/home/diogo/RPG/Eberron/Images/session06/SilverwoodDaoDao.jpg";

    std.debug.print("Testing progressive JPEG: {s}\n", .{path});
    std.debug.print("Image info: 960x540 RGB progressive\n\n", .{});

    var img = stbz.loadJpegFile(allocator, path) catch |err| {
        std.debug.print("✗ Failed to load: {}\n", .{err});
        return err;
    };
    defer img.deinit();

    std.debug.print("✓ SUCCESS!\n", .{});
    std.debug.print("  Dimensions: {}x{}\n", .{img.width, img.height});
    std.debug.print("  Channels: {}\n", .{img.channels});
    std.debug.print("  Data size: {} bytes\n", .{img.data.len});
}
