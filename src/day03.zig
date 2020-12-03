const std = @import("std");
const input = @embedFile("input/03.txt");
const aoc = @import("aoc.zig");

fn slopeCount(map: []const []const u8, dx: usize, dy: usize) usize {
    var hit_trees: usize = 0;
    var x: usize = 0;
    var y: usize = 0;
    while (y < map.len) : (y += dy) {
        if (map[y][x % map[y].len] == '#') hit_trees += 1;
        x += dx;
    }

    return hit_trees;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const map = blk: {
        var lines = std.ArrayList([]const u8).init(allocator);
        var it = std.mem.tokenize(input, "\n");
        while (it.next()) |line| {
            try lines.append(line);
        }

        break :blk lines.toOwnedSlice();
    };

    const a = slopeCount(map, 1, 1);
    const b = slopeCount(map, 3, 1);
    const c = slopeCount(map, 5, 1);
    const d = slopeCount(map, 7, 1);
    const e = slopeCount(map, 1, 2);

    aoc.print("Day 03, part 1: {}\n", .{ b });
    aoc.print("Day 03, part 2: {}\n", .{ a * b * c * d * e });
}
