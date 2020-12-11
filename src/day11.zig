const std = @import("std");
const input = @embedFile("input/11.txt");
const aoc = @import("aoc.zig");

const Map = struct {
    w: usize,
    h: usize,
    cells: []u8,

    fn dupe(self: Map, allocator: *std.mem.Allocator) !Map {
        return Map{
            .w = self.w,
            .h = self.h,
            .cells = try std.mem.dupe(allocator, u8, self.cells),
        };
    }

    fn index(self: Map, x: usize, y: usize) usize {
        return y * (self.w + 1) + x;
    }

    fn at(self: Map, x: usize, y: usize) *u8 {
        std.debug.assert(x < self.w and y < self.h);
        return &self.cells[self.index(x, y)];
    }

    fn getRela(self: Map, x: usize, y: usize, dx: isize, dy: isize) ?u8 {
        const bx = @intCast(isize, x) + dx;
        const by = @intCast(isize, y) + dy;

        if (bx < 0 or bx >= self.w or by < 0 or by >= self.h) {
            return null;
        }

        return self.at(
            @intCast(usize, bx),
            @intCast(usize, by),
        ).*;
    }

    fn checkRela(self: Map, x: usize, y: usize, dx: isize, dy: isize, ray: bool) bool {
        var cx = dx;
        var cy = dy;

        while (true) {
            const c = self.getRela(x, y, cx, cy) orelse return false;
            switch (c) {
                '.' => if (!ray) return false,
                '#' => return true,
                'L' => return false,
                else => unreachable,
            }

            cx += dx;
            cy += dy;
        }
    }

    fn dump(self: Map) void {
        var y: usize = 0;
        while (y < self.h) : (y += 1) {
            var x: usize = 0;
            while (x < self.w) : (x += 1) {
                std.debug.print("{c}", .{ self.at(x, y).* });
            }
            std.debug.print("\n", .{});
        }
    }

    fn setAllOccupied(self: Map) void {
        var y: usize = 0;
        while (y < self.h) : (y += 1) {
            var x: usize = 0;
            while (x < self.w) : (x += 1) {
                const p = self.at(x, y);
                if (p.* == 'L') p.* = '#';
            }
        }
    }

    fn countOccupied(self: Map) usize {
        var o: usize = 0;
        var y: usize = 0;
        while (y < self.h) : (y += 1) {
            var x: usize = 0;
            while (x < self.w) : (x += 1) {
                if (self.at(x, y).* == '#') o += 1;
            }
        }

        return o;
    }
};

fn solve(a: Map, b: Map, ray: bool) usize {
    a.setAllOccupied();
    const min: usize = if (ray) 5 else 4;

    var changed = true;
    var i: usize = 0;
    while (changed) : (i += 1) {
        changed = false;
        const src = if (i % 2 == 0) &a else &b;
        const dst = if (i % 2 == 0) &b else &a;

        var y: usize = 0;
        while (y < a.h) : (y += 1) {
            var x: usize = 0;
            while (x < a.w) : (x += 1) {
                var on: usize = 0;
                const orig = src.at(x, y).*;
                if (orig == '.') {
                    dst.at(x, y).* = '.';
                    continue;
                }

                if (src.checkRela(x, y, -1, -1, ray)) on += 1;
                if (src.checkRela(x, y, -1,  0, ray)) on += 1;
                if (src.checkRela(x, y, -1,  1, ray)) on += 1;

                if (src.checkRela(x, y,  0, -1, ray)) on += 1;
                if (src.checkRela(x, y,  0,  1, ray)) on += 1;

                if (src.checkRela(x, y,  1, -1, ray)) on += 1;
                if (src.checkRela(x, y,  1,  0, ray)) on += 1;
                if (src.checkRela(x, y,  1,  1, ray)) on += 1;

                var new: u8 = if (orig == 'L' and on == 0)
                        '#'
                    else if (orig == '#' and on >= min)
                        'L'
                    else
                        orig;

                if (new != orig) changed = true;
                dst.at(x, y).* = new;
            }
        }
    }

    return a.countOccupied();
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const h = std.mem.count(u8, input, "\n");
    const w = std.mem.indexOfScalar(u8, input, '\n').?;

    var a = Map{
        .w = w,
        .h = h,
        .cells = try std.mem.dupe(allocator, u8, input)
    };

    var b = Map{
        .w = w,
        .h = h,
        .cells = try allocator.alloc(u8, input.len)
    };

    aoc.print("Day 11, part 1: {}\n", .{ solve(try a.dupe(allocator), try b.dupe(allocator), false) });
    aoc.print("Day 11, part 2: {}\n", .{ solve(a, b, true) });
}
