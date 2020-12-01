const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn splitToIntegers(
    comptime T: type,
    allocator: *std.mem.Allocator,
    data: []const u8,
    delim: []const u8
) ![]const T {
    var items = std.ArrayList(T).init(allocator);
    errdefer items.deinit();

    var it = std.mem.split(data, delim);
    while (it.next()) |line| {
        if (line.len == 0) continue;
        const value = try std.fmt.parseInt(T, line, 10);
        try items.append(value);
    }

    return items.toOwnedSlice();
}

pub fn print(comptime fmt: []const u8, args: anytype) void {
    std.io.getStdOut().writer().print(fmt, args) catch unreachable;
}