const std = @import("std");
const input = @embedFile("input/15.txt");
const aoc = @import("aoc.zig");

const start = [_]usize{18, 11, 9, 0, 5, 1};

pub fn main() !void {
    var last_seen = try std.heap.page_allocator.alloc(usize, 30000000);
    std.mem.set(usize, last_seen, 0);

    var i: usize = 1;
    var last: usize = start[0];
    while (i <= 30000000) : (i += 1) {
        const num = if (i <= start.len)
                start[i - 1]
            else if (last_seen[last] == 0)
                0
            else
                i - last_seen[last] - 1;
        last_seen[last] = i - 1;
        last = num;

        if (i == 2020) {
            aoc.print("Day 15, part 1: {}\n", .{ last });
        }
    }

    aoc.print("Day 15, part 2: {}\n", .{ last });
}
