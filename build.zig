const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Main library module
    const stbz_mod = b.addModule("stbz", .{
        .root_source_file = b.path("src/stbz.zig"),
    });

    // CLI executable
    const exe = b.addExecutable(.{
        .name = "stbz",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/cli.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addImport("stbz", stbz_mod);
    exe.root_module.addIncludePath(b.path("reference"));
    exe.root_module.addCSourceFile(.{
        .file = b.path("reference/ref_impl.c"),
        .flags = &.{"-std=c99"},
    });
    exe.root_module.link_libc = true;

    b.installArtifact(exe);

    // Run step
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the CLI");
    run_step.dependOn(&run_cmd.step);

    // Unit tests for stbz library
    const unit_tests = b.addTest(.{
        .name = "stbz-tests",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/stbz.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    // Comparison tests (Zig vs C reference)
    const compare_tests = b.addTest(.{
        .name = "compare-tests",
        .root_module = b.createModule(.{
            .root_source_file = b.path("test/test_png.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    compare_tests.root_module.addImport("stbz", stbz_mod);
    compare_tests.root_module.addIncludePath(b.path("reference"));
    compare_tests.root_module.addCSourceFile(.{
        .file = b.path("reference/ref_impl.c"),
        .flags = &.{"-std=c99"},
    });
    compare_tests.root_module.link_libc = true;

    const run_compare_tests = b.addRunArtifact(compare_tests);

    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&run_unit_tests.step);
    test_step.dependOn(&run_compare_tests.step);
}
