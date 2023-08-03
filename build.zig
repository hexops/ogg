const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "ogg",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addIncludePath(.{ .path = "include" });
    lib.addCSourceFiles(&sources, &.{"-fno-sanitize=undefined"});
    lib.installHeadersDirectory("include/ogg", "ogg");
    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "src/bitwise.c",
    "src/framing.c",
};
