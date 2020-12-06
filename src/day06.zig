const std = @import("std");
const input = @embedFile("input/06.txt");
const aoc = @import("aoc.zig");

pub fn main() void {
    var it = std.mem.split(aoc.stripTrailingNewline(input), "\n\n");
    var any_total: usize = 0;
    var every_total: usize = 0;
    while (it.next()) |line| {
        var answer_counts = [_]u32{0} ** 26;
        var n_in_group: usize = 1;

        for (line) |c| {
            if (c == '\n') {
                n_in_group += 1;
                continue;
            }

            any_total += @boolToInt(answer_counts[c - 'a'] == 0);
            answer_counts[c - 'a'] += 1;
        }

        for (answer_counts) |a, i| {
            if (a == n_in_group) {
                every_total += 1;
            }
        }
    }

    aoc.print("Day 06, part 1: {}\n", .{ any_total });
    aoc.print("Day 06, part 2: {}\n", .{ every_total });
}
