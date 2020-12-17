const std = @import("std");
const input = @embedFile("input/17.txt");
const aoc = @import("aoc.zig");

const Coord = struct {
    x: i32, y: i32, z: i32, w: i32,

    fn min(a: Coord, b: Coord) Coord {
        return .{
            .x = std.math.min(a.x, b.x),
            .y = std.math.min(a.y, b.y),
            .z = std.math.min(a.z, b.z),
            .w = std.math.min(a.w, b.w),
        };
    }

    fn max(a: Coord, b: Coord) Coord {
        return .{
            .x = std.math.max(a.x, b.x),
            .y = std.math.max(a.y, b.y),
            .z = std.math.max(a.z, b.z),
            .w = std.math.max(a.w, b.w),
        };
    }

    fn add(a: Coord, b: Coord) Coord {
        return .{
            .x = a.x + b.x,
            .y = a.y + b.y,
            .z = a.z + b.z,
            .w = a.w + b.w,
        };
    }
};

const RangeIter = struct {
    min: Coord,
    max: Coord,
    current: Coord,

    fn init(min: Coord, max: Coord) RangeIter {
        return .{
            .min = min,
            .max = max,
            .current = min,
        };
    }

    fn next(self: *RangeIter) ?Coord {
        const i = self.current;
        if (i.w > self.max.w) {
            return null;
        }

        if (i.x == self.max.x) {
            self.current.x = self.min.x;
            if (i.y == self.max.y) {
                self.current.y = self.min.y;
                if (i.z == self.max.z) {
                    self.current.z = self.min.z;
                    self.current.w += 1;
                } else {
                    self.current.z += 1;
                }
            } else {
                self.current.y += 1;
            }
        } else {
            self.current.x += 1;
        }

        return i;
    }
};

const Map = struct {
    active_cells: std.AutoArrayHashMap(Coord, void),
    min: Coord,
    max: Coord,

    fn init(allocator: *std.mem.Allocator) Map {
        return .{
            .active_cells = std.AutoArrayHashMap(Coord, void).init(allocator),
            .min = .{.x = 0, .y = 0, .z = 0, .w = 0},
            .max = .{.x = 0, .y = 0, .z = 0, .w = 0},
        };
    }

    fn clear(self: *Map) void {
        self.active_cells.clearRetainingCapacity();
        self.min = .{.x = 0, .y = 0, .z = 0, .w = 0};
        self.max = .{.x = 0, .y = 0, .z = 0, .w = 0};
    }

    fn setActive(self: *Map, x: Coord) !void {
        try self.active_cells.put(x, {});
        if (self.active_cells.count() == 1) {
            self.min = x;
            self.max = x;
        } else {
            self.min = self.min.min(x);
            self.max = self.max.max(x);
        }
    }

    fn isActive(self: Map, x: Coord) bool {
        return self.active_cells.get(x) != null;
    }

    fn simul8(src: Map, dst: *Map, four_d: bool) !void {
        dst.clear();

        var it = RangeIter.init(
            src.min.add(.{.x = -1, .y = -1, .z = -1, .w = if (four_d) -1 else 0}),
            src.max.add(.{.x =  1, .y =  1, .z =  1, .w = if (four_d)  1 else 0}),
        );

        while (it.next()) |coord| {
            var active_neighbors: usize = 0;
            var inner_it = RangeIter.init(
                .{.x = -1, .y = -1, .z = -1, .w = if (four_d) -1 else 0},
                .{.x =  1, .y =  1, .z =  1, .w = if (four_d)  1 else 0}
            );

            while (inner_it.next()) |neigh| {
                if (!std.meta.eql(neigh, .{.x = 0, .y = 0, .z = 0, .w = 0}) and src.isActive(neigh.add(coord))) {
                    active_neighbors += 1;
                }
            }

            const active = src.isActive(coord);
            if ((active and active_neighbors == 2) or active_neighbors == 3) {
                try dst.setActive(coord);
            }
        }
    }
};

fn parseInput(allocator: *std.mem.Allocator) !Map {
    var m = Map.init(allocator);

    var it = std.mem.tokenize(input, "\n");
    var y: i32 = 0;
    while (it.next()) |line| {
        for (line) |c, x| {
            if (c == '#') {
                try m.setActive(.{.x = @intCast(i32, x), .y = y, .z = 0, .w = 0});
            }
        }

        y -= 1;
    }

    return m;
}

fn boot(allocator: *std.mem.Allocator, four_d: bool) !usize {
    var a = try parseInput(allocator);
    var b = Map.init(allocator);

    var i: usize = 0;
    while (i < 6) : (i += 1) {
        const src = if (i % 2 == 0) &a else &b;
        const dst = if (i % 2 != 0) &a else &b;
        try src.simul8(dst, four_d);
    }

    return a.active_cells.count();
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    aoc.print("Day 17, part 1: {}\n", .{ try boot(allocator, false) });
    aoc.print("Day 17, part 2: {}\n", .{ try boot(allocator, true) });
}
