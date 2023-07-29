const std = @import("std");

pub fn build(b: *std.Build) void {
    const cross_target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "ogg",
        .target = cross_target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addIncludePath("include");
    lib.addCSourceFiles(&sources, &.{});
    lib.installHeadersDirectory("include", "");
    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "src/bitwise.c",
    "src/framing.c",
};
