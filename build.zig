const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const config_header = b.addConfigHeader(
        .{
            .style = .{ .cmake = .{ .path = sdkPath("/include/ogg/config_types.h.in") } },
            .include_path = sdkPath("/ogg/config_types.h"),
        },
        .{
            .INCLUDE_INTTYPES_H = 0,
            .INCLUDE_STDINT_H = 1,
            .INCLUDE_SYS_TYPES_H = 0,
            .SIZE16 = .int16_t,
            .USIZE16 = .uint16_t,
            .SIZE32 = .int32_t,
            .USIZE32 = .uint32_t,
            .SIZE64 = .int64_t,
            .USIZE64 = .uint64_t,
        },
    );

    const lib = b.addStaticLibrary(.{
        .name = "ogg",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addConfigHeader(config_header);
    lib.addIncludePath(.{ .path = "include" });
    lib.addCSourceFiles(.{ .files = &sources, .flags = &.{"-fno-sanitize=undefined"} });
    lib.installHeadersDirectoryOptions(.{
        .source_dir = .{ .path = "include/ogg" },
        .install_dir = .header,
        .install_subdir = "ogg",
        .exclude_extensions = &.{".in"},
    });
    lib.installConfigHeader(config_header, .{
        .dest_rel_path = "ogg/config_types.h",
    });
    b.installArtifact(lib);
}

const sources = [_][]const u8{
    "src/bitwise.c",
    "src/framing.c",
};

fn sdkPath(comptime suffix: []const u8) []const u8 {
    if (suffix[0] != '/') @compileError("suffix must be an absolute path");
    return comptime blk: {
        const root_dir = std.fs.path.dirname(@src().file) orelse ".";
        break :blk root_dir ++ suffix;
    };
}
