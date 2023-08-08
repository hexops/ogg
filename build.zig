const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // TODO: use https://github.com/ziglang/zig/pull/16689 once it's merged
    // const config_header = b.addConfigHeader(
    //     .{
    //         .style = .{ .cmake = .{ .path = "include/ogg/config_types.h.in" } },
    //         .include_path = "ogg/config_types.h",
    //     },
    //     .{
    //         .INCLUDE_INTTYPES_H = 0,
    //         .INCLUDE_STDINT_H = 1,
    //         .INCLUDE_SYS_TYPES_H = 0,
    //         .SIZE16 = .int16_t,
    //         .USIZE16 = .uint16_t,
    //         .SIZE32 = .int32_t,
    //         .USIZE32 = .uint32_t,
    //         .SIZE64 = .int64_t,
    //         .USIZE64 = .uint64_t,
    //     },
    // );

    const lib = b.addStaticLibrary(.{
        .name = "ogg",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addIncludePath(.{ .path = "include" });
    lib.addCSourceFiles(&sources, &.{"-fno-sanitize=undefined"});
    // lib.addConfigHeader(config_header);
    lib.installHeadersDirectory("include/ogg", "ogg");
    // lib.installConfigHeader(config_header, .{});
    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "src/bitwise.c",
    "src/framing.c",
};
