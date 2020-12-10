const std = @import("std");
const input = @embedFile("input/09.txt");
const aoc = @import("aoc.zig");

const IteratorPair = struct {
    i: usize,
    j: usize
};

fn findSum(list: []const usize, value: usize) bool {
    for (list) |a| {
        for (list) |b| {
            if (a + b == value) {
                return true;
            }
        }
    }

    return false;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const list = (try aoc.splitToIntegers(usize, allocator, input, "\n")).items;

    const p = 25;
    var i: usize = p;
    var target = while (i < list.len) : (i += 1) {
        if (!findSum(list[i - p .. i], list[i])) {
            break list[i];
        }
    } else unreachable;

    aoc.print("Day 09, part 1: {}\n", .{ target });

    var j: usize = 0;
    var k: usize = 0;
    var sum = list[0];

    while (k < list.len) {
        if (sum == target) {
            const max = std.sort.max(usize, list[j .. k], {}, comptime std.sort.asc(usize));
            const min = std.sort.min(usize, list[j .. k], {}, comptime std.sort.asc(usize));

            aoc.print("Dat 09, part 2: {}\n", .{ max.? + min.? });
            break;
        } else if (sum < target) {
            k += 1;
            sum += list[k];
        } else if (sum > target) {
            sum -= list[j];
            j += 1;
        }
    }
}
