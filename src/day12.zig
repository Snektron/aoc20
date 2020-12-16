const std = @import("std");
const input = @embedFile("input/12.txt");
const aoc = @import("aoc.zig");

const Dir = enum {
    north, east, south, west,

    fn cw(self: Dir) Dir {
        return switch (self) {
            .north => .east,
            .east => .south,
            .south => .west,
            .west => .north,
        };
    }

    fn ccw(self: Dir) Dir {
        return switch (self) {
            .north => .west,
            .east => .north,
            .south => .east,
            .west => .south,
        };
    }

    fn move(self: Dir, amt: isize, x: *isize, y: *isize) void {
        switch (self) {
            .north => y.* += amt,
            .east => x.* += amt,
            .south => y.* -= amt,
            .west => x.* -= amt,
        }
    }
};

fn part1() !void {
    var it = std.mem.tokenize(input, "\n");
    var x: isize = 0;
    var y: isize = 0;
    var d = Dir.east;

    while (it.next()) |line| {
        const a = line[0];
        const b = try std.fmt.parseInt(isize, line[1..], 10);

        switch (a) {
            'F' => d.move(b, &x, &y),
            'N' => Dir.north.move(b, &x, &y),
            'E' => Dir.east.move(b, &x, &y),
            'S' => Dir.south.move(b, &x, &y),
            'W' => Dir.west.move(b, &x, &y),
            'R' => {
                var i: isize = 0;
                while (i < b) : (i += 90) {
                    d = d.cw();
                }
            },
            'L' => {
                var i: isize = 0;
                while (i < b) : (i += 90) {
                    d = d.ccw();
                }
            },
            else => {},
        }
    }

    aoc.print("Day 12, part 1: {}\n", .{ std.math.absCast(x) + std.math.absCast(y) });
}

fn part2() !void {
    var it = std.mem.tokenize(input, "\n");
    var x: isize = 0;
    var y: isize = 0;
    var wx: isize = 10;
    var wy: isize = 1;

    while (it.next()) |line| {
        const a = line[0];
        const b = try std.fmt.parseInt(isize, line[1..], 10);

        switch (a) {
            'F' => {
                x += wx * b;
                y += wy * b;
            },
            'N' => Dir.north.move(b, &wx, &wy),
            'E' => Dir.east.move(b, &wx, &wy),
            'S' => Dir.south.move(b, &wx, &wy),
            'W' => Dir.west.move(b, &wx, &wy),
            'R' => {
                var i: isize = 0;
                while (i < b) : (i += 90) {
                    const tmp = wx;
                    wx = wy;
                    wy = -tmp;
                }
            },
            'L' => {
                var i: isize = 0;
                const dx = wx - x;
                const dy = wy - y;
                while (i < b) : (i += 90) {
                    const tmp = wx;
                    wx = -wy;
                    wy = tmp;
                }
            },
            else => unreachable,
        }
    }

    aoc.print("Day 12, part 2: {}\n", .{ std.math.absCast(x) + std.math.absCast(y) });
}

pub fn main() !void {
    try part1();
    try part2();
}
