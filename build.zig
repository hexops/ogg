const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const config_header = b.addConfigHeader(.{
        .style = .{ .autoconf = .{ .path = "include/ogg/config_types.h.in" } },
        .include_path = "config_types.h",
    }, .{});

    const lib = b.addStaticLibrary(.{
        .name = "ogg",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addIncludePath(.{ .path = "include" });
    lib.addCSourceFiles(&sources, &.{"-fno-sanitize=undefined"});
    lib.addConfigHeader(config_header);
    lib.installHeadersDirectory("include/ogg", "ogg");
    lib.installConfigHeader(config_header, .{});
    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "src/bitwise.c",
    "src/framing.c",
};
