const std = @import("std");
const input = @embedFile("input/24.txt");
const aoc = @import("aoc.zig");
const Allocator = std.mem.Allocator;

const HexCoord = struct {
    x: i32,
    y: i32,
};

fn walk(dirs: []const u8) HexCoord {
    var c = HexCoord{.x = 0, .y = 0};

    var i: usize = 0;
    while (i < dirs.len) : (i += 1) {
        // std.debug.print("{c} {} {}\n", .{ dirs[i], c.x, c.y });
        switch (dirs[i]) {
            'e' => c.x += 1,
            'w' => c.x -= 1,
            'n' => {
                i += 1;
                c.y += 1;
                switch (dirs[i]) {
                    'w' => c.x -= 1,
                    'e' => {},
                    else => unreachable,
                }
            },
            's' => {
                i += 1;
                c.y -= 1;
                switch (dirs[i]) {
                    'w' => {},
                    'e' => c.x += 1,
                    else => unreachable,
                }
            },
            else => unreachable,
        }
    }

    return c;
}

const Side = enum {
    white,
    black,

    fn flip(self: *Side) void {
        self.* = switch (self.*) {
            .white => .black,
            .black => .white,
        };
    }
};

fn count(floor: std.AutoArrayHashMap(HexCoord, Side)) usize {
    var total: usize = 0;
    var hmit = floor.iterator();
    while (hmit.next()) |entry| {
        if (entry.value == .black) total += 1;
    }
    return total;
}

fn simulate(src: *std.AutoArrayHashMap(HexCoord, Side), dst: *std.AutoArrayHashMap(HexCoord, Side)) !void {
    dst.clearRetainingCapacity();

    const neighbors = [_]HexCoord{
        .{.x = 1, .y = 0},
        .{.x = -1, .y = 0},
        .{.x = 0, .y = 1},
        .{.x = 0, .y = -1},
        .{.x = -1, .y = 1},
        .{.x = 1, .y = -1},
    };

    var it = src.iterator();
    while (it.next()) |entry| {
        const c = entry.key;
        var adj: usize = 0;

        for (neighbors) |n| {
            const c0 = HexCoord{.x = c.x + n.x, .y = c.y + n.y};
            if ((src.get(c0) orelse .white) == .black) adj += 1;
        }

        const col = if (entry.value == .black and (adj == 0 or adj > 2))
                .white
            else if (entry.value == .white and adj == 2)
                .black
            else
                entry.value;

        try dst.put(c, col);
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var floor = std.AutoArrayHashMap(HexCoord, Side).init(allocator);

    var x: i32 = -200;
    while (x <= 200) : (x += 1) {
        var y: i32 = -200;
        while (y <= 200) : (y += 1) {
            try floor.put(.{.x = x, .y = y}, .white);
        }
    }

    var it = std.mem.tokenize(input, "\n");
    while (it.next()) |line| {
        const c = walk(line);
        const result = try floor.getOrPut(c);
        if (!result.found_existing) {
            unreachable;
        } else {
            result.entry.value.flip();
        }
    }

    aoc.print("Day 24, part 1: {}\n", .{ count(floor) });

    var floor2 = std.AutoArrayHashMap(HexCoord, Side).init(allocator);

    var i: usize = 0;
    while (i < 100) : (i += 1) {
        if (i % 2 == 0) {
            try simulate(&floor, &floor2);
        } else {
            try simulate(&floor2, &floor);
        }
    }

    aoc.print("Day 24, part 2: {}\n", .{ count(floor) });
}
