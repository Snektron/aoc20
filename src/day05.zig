const std = @import("std");
const input = @embedFile("input/05.txt");
const aoc = @import("aoc.zig");

fn seatToId(seat: []const u8) usize {
    var value: usize = 0;
    for (seat) |c, i| {
        var x = @as(usize, 1) << @intCast(u4, 10 - i - 1);
        switch (c) {
            'F', 'L' => {},
            'B', 'R' => value |= x,
            else => unreachable,
        }
    }

    return value;
}

pub fn main() void {
    var it = std.mem.tokenize(input, "\n");

    var seats = [_]bool{false} ** 1024;
    var max_id: usize = 0;
    while (it.next()) |line| {
        const id = seatToId(line);
        max_id = std.math.max(max_id, id);
        seats[id] = true;
    }

    aoc.print("Day 05, part 1: {}\n", .{ max_id });

    var i: usize = 1;
    while (i < seats.len - 1) : (i += 1) {
        if (!seats[i] and seats[i - 1] and seats[i + 1]) {
            aoc.print("Day 05, part 2: {}\n", .{ i });
            break;
        }
    }
}
