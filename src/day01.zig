const std = @import("std");
const input = @embedFile("input/01.txt");
const aoc = @import("aoc.zig");

const IteratorPair = struct {
    i: usize,
    j: usize
};

fn findSum(list: []u16, value: u16) ?IteratorPair {
    var i: usize = 0;
    var j: usize = list.len - 1;

    while (i != j) {
        const sum = list[i] + list[j];
        if (sum == value) {
            return IteratorPair{.i = i, .j = j};
        } else if (sum > value) {
            j -= 1;
        } else {
            i += 1;
        }
    }

    return null;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const list = (try aoc.splitToIntegers(u16, allocator, input, "\n")).items;

    try aoc.radixSortAlloc(u16, 4, allocator, list);

    {
        const iters = findSum(list, 2020).?;
        const a = list[iters.i];
        const b = list[iters.j];
        aoc.print("Day 01, part 1: {}\n", .{ @as(usize, a) * b });
    }

    for (list) |a| {
        const iters = findSum(list, 2020 - a) orelse continue;
        const b = list[iters.i];
        const c = list[iters.j];
        aoc.print("Day 01, part 2: {}\n", .{ @as(usize, a) * b * c });
        break;
    }
}
