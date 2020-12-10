const std = @import("std");
const input = @embedFile("input/10.txt");
const aoc = @import("aoc.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var list = try aoc.splitToIntegers(u16, allocator, input, "\n");
    try list.append(0);
    var items = list.items;

    try aoc.radixSortAlloc(u16, 4, allocator, items);

    var counts = [_]usize{0} ** 3;
    for (items[1..]) |v, i| {
        counts[v - items[i] - 1] += 1;
    }

    counts[2] += 1;
    aoc.print("Day 10, part 1: {}\n", .{ counts[0] * counts[2] });

    var x = [_]usize{1, 0, 0, 0};

    var i: usize = 1;
    while (i < items.len) : (i += 1) {
        const b = items[i];
        var j = if (i < 3) 0 else i - 3;

        x[i % 4] = 0;
        for (items[j .. i]) |c, k| {
            if (b - c <= 3) {
                x[i % 4] += x[(k + j) % 4];
            }
        }
    }

    aoc.print("Day 10, part 2: {}\n", .{ x[(i - 1) % 4] });
}
