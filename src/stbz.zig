const std = @import("std");
const Allocator = std.mem.Allocator;

pub const image = @import("image.zig");
pub const Image = image.Image;
pub const png = @import("png.zig");

pub const loadPngFile = png.loadFromFile;
pub const loadPngMemory = png.loadFromMemory;
pub const savePngFile = png.saveToFile;
pub const savePngMemory = png.saveToMemory;

test {
    std.testing.refAllDecls(@This());
}
