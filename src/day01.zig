const std = @import("std");
const input = @embedFile("input/01.txt");
const aoc = @import("aoc.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const list = try aoc.splitToIntegers(u16, allocator, input, "\n");

    try aoc.radixSortAlloc(u16, 4, allocator, list);

    {
        aoc.print("Part 1:\n", .{});
        var i: usize = 0;
        var j: usize = list.len - 1;

        while (i != j) {
            const sum = list[i] + list[j];
            if (sum == 2020) {
                aoc.print("{} * {} = {}\n", .{ list[i], list[j], @as(usize, list[i]) * list[j] });
                break;
            } else if (sum > 2020) {
                j -= 1;
            } else {
                i += 1;
            }
        }
    }

    aoc.print("Part 2:\n", .{});
    for (list[2 ..]) |a, i| {
        for (list[1 .. i + 2]) |b, j| {
            for (list[0 .. j + 1]) |c| {
                if (a + b + c == 2020) {
                    aoc.print("{} * {} * {} = {}\n", .{ a, b, c, @as(usize, a) * b * c });
                }
            }
        }
    }
}
