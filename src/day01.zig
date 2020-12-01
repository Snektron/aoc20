const std = @import("std");
const input = @embedFile("input/01.txt");
const aoc = @import("aoc.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const list = try aoc.splitToIntegers(u64, allocator, input, "\n");

    aoc.print("Part 1\n", .{});
    for (list[0 .. list.len - 1]) |a, i| {
        for (list[i + 1..]) |b| {
            if (a + b == 2020) {
                aoc.print("{} * {} = {}\n", .{ a, b, a * b });
            }
        }
    }

    aoc.print("Part 2\n", .{});
    for (list[0 .. list.len - 2]) |a, i| {
        for (list[i + 1 .. list.len - 1]) |b, j| {
            for (list[j + 1 ..]) |c| {
                if (a + b + c == 2020) {
                    aoc.print("{} * {} * {} = {}\n", .{ a, b, c, a * b * c });
                }
            }
        }
    }
}
