const std = @import("std");
const input = @embedFile("input/25.txt");
const aoc = @import("aoc.zig");
const Allocator = std.mem.Allocator;

const key1 = 15628416;
const key2 = 11161639;

fn transform(x: usize, s: usize) usize {
    return (x * s) % 20201227;
}

fn loop(sub: usize, target: usize) usize {
    var x: usize = 1;
    var i: usize = 0;
    while (x != target) : (i += 1) {
        x = transform(x, sub);
    }

    return i;
}

fn transformLoop(sub: usize, amt: usize) usize {
    var x: usize = 1;
    var i: usize = 0;
    while (i < amt) : (i += 1) {
        x = transform(x, sub);
    }

    return x;
}

pub fn main() !void {
    const loop1 = loop(7, key1);
    const loop2 = loop(7, key2);

    std.debug.print("{} {}\n", .{ loop1, loop2 });

    std.debug.print("{}\n", .{ transformLoop(key1, loop2) });
    std.debug.print("{}\n", .{ transformLoop(key2, loop1) });
}
