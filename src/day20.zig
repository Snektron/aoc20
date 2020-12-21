const std = @import("std");
const input = @embedFile("input/20.txt");
const aoc = @import("aoc.zig");
const Allocator = std.mem.Allocator;

const Dir = enum(u2) {
    north,
    east,
    south,
    west,

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

    fn add(a: Dir, b: Dir) Dir {
        return @intToEnum(Dir, @enumToInt(a) +% @enumToInt(b));
    }

    fn sub(a: Dir, b: Dir) Dir {
        return @intToEnum(Dir, @enumToInt(a) -% @enumToInt(b));
    }

    fn flip(self: Dir) Dir {
        return switch (self) {
            .north => .north,
            .east => .west,
            .south => .south,
            .west => .east,
        };
    }
};

const Flip = enum {
    none,
    horizontal,
    vertical,
};

const OverlappedEdge = struct {
    orientation: Dir,
    flipped: bool,
};

const Tile = struct {
    const width = 10;
    const height = 10;

    id: usize,
    cells: [height][width]bool,
    overlapping: [4]bool,

    fn check(self: Tile, x: usize, y: usize) bool {
        return self.cells[y][x];
    }

    fn edgeBits(self: Tile, edge: Dir, flipped: bool) u10 {
        var bits: u10 = 0;

        switch (edge) {
            .north => for (self.cells[0]) |x, i| {
                if (x) bits |= @as(u10, 1) << @intCast(u4, i);
            },
            .east => {
                var y: u4 = 0;
                while (y < 10) : (y += 1) {
                    if (self.cells[y][9]) {
                        bits |= @as(u10, 1) << y;
                    }
                }
            },
            .south => for (self.cells[9]) |x, i| {
                if (x) bits |= @as(u10, 1) << @intCast(u4, 9 - i);
            },
            .west => {
                var y: u4 = 0;
                while (y < 10) : (y += 1) {
                    if (self.cells[y][0]) {
                        bits |= @as(u10, 1) << (9 - y);
                    }
                }
            },
        }

        if (flipped) {
            bits = @bitReverse(u10, bits);
        }

        return bits;
    }

    fn dump(self: Tile) void {
        std.debug.print("Tile {}:\n", .{ self.id });
        for (self.cells) |row| {
            for (row) |cell| {
                const text: u8 = if (cell) '#' else '.';
                std.debug.print("{c}", .{ text });
            }
            std.debug.print("\n", .{});
        }
    }

    fn parse(text: []const u8) !Tile {
        var it = std.mem.tokenize(text, " \n:");
        _ = it.next().?; // 'Tile'

        var self = Tile{
            .id = try std.fmt.parseInt(usize, it.next().?, 10),
            .cells = undefined,
            .overlapping = undefined,
        };

        var y: usize = 0;
        while (it.next()) |line| {
            for (line) |c, x| {
                self.cells[y][x] = c == '#';
            }
            y += 1;
        }

        return self;
    }
};

fn parseTiles(allocator: *Allocator) ![]Tile {
    var tiles = std.ArrayList(Tile).init(allocator);

    var it = std.mem.split(input, "\n\n");
    while (it.next()) |tile| {
        try tiles.append(try Tile.parse(tile));
    }

    return tiles.toOwnedSlice();
}

const PlacedTile = struct {
    index: usize,
    orientation: Dir,
    flip_x: bool,
    flip_y: bool,
};

const TileMap = struct {
    const max_width = 12;
    const max_height = 12;

    width: usize,
    height: usize,
    tiles: [max_height][max_width]?PlacedTile,

    fn init(width: usize, height: usize) TileMap {
        return .{
            .width = width,
            .height = height,
            .tiles = [_][max_height]?PlacedTile{
                [_]?PlacedTile{null} ** max_width
            } ** max_height,
        };
    }

    fn dump(self: TileMap, tiles: []Tile) void {
        var y: usize = 0;
        while (y < self.height) : (y += 1) {
            var yt: usize = 0;
            while (yt < 10) : (yt += 1) {
                var x: usize = 0;
                while (x < self.width) : (x += 1) {
                    var xt: usize = 0;
                    while (xt < 10) : (xt += 1) {
                        self.dumpTilePart(x, y, xt, yt, tiles);
                    }

                    std.debug.print(" ", .{});
                }
                std.debug.print("\n", .{});
            }
            std.debug.print("\n", .{});
        }
    }

    fn dumpTilePart(self: TileMap, tx: usize, ty: usize, x: usize, y: usize, tiles: []Tile) void {
        const t = self.tiles[ty][tx] orelse {
            std.debug.print("-", .{});
            return;
        };

        var x0: usize = undefined;
        var y0: usize = undefined;

        switch (t.orientation) {
            .north => { x0 = x; y0 = y; },
            .east => { x0 = y; y0 = 9 - x; },
            .south => { x0 = 9 - x ; y0 = 9 - y; },
            .west => { x0 = 9 - y ; y0 = x; },
        }

        if (t.flip_x) {
            x0 = 9 - x0;
        }

        if (t.flip_y) {
            y0 = 9 - y0;
        }

        const c: u8 = if (tiles[t.index].check(x0, y0)) '#' else '.';
        std.debug.print("{c}", .{c});
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const tiles = try parseTiles(allocator);

    const dirs = [_]Dir{.north, .east, .south, .west};
    const flips = [_]bool{false, true};

    var part1: usize = 1;
    var corner: usize = 0;
    for (tiles) |*t0, i| {
        var overlaps: usize = 0;
        for (dirs) |d0| {
            var overlaps_any = false;
            for (tiles) |t1, j| {
                if (i == j) continue;
                for (dirs) |d1| {
                    for (flips) |flip| {
                        const e1 = t0.edgeBits(d0, flip);
                        const e2 = t1.edgeBits(d1, false);
                        if (e1 == e2) {
                            overlaps += 1;
                            overlaps_any = true;
                        }
                    }
                }
            }

            t0.overlapping[@enumToInt(d0)] = overlaps_any;
        }

        if (overlaps == 2) {
            part1 *= t0.id;
            corner = i;
        }
    }

    aoc.print("Day 20, part 1: {}\n", .{ part1 });

    // Find the rotation such that the corner fits in the upper left corner
    // There will be two bools set to true in `overlapping`, the second needs to be north

    const first_orientation = if (tiles[corner].overlapping[0] and tiles[corner].overlapping[1])
            Dir.east
        else if (tiles[corner].overlapping[1] and tiles[corner].overlapping[2])
            Dir.south
        else if (tiles[corner].overlapping[2] and tiles[corner].overlapping[3])
            Dir.west
        else
            Dir.north;


    std.debug.print("{} {} {}\n", .{ corner, tiles[corner].id, first_orientation });

    var map = TileMap.init(3, 3);
    map.tiles[0][0] = PlacedTile{
        .index = corner,
        .orientation = .north,
        .flip_x = false,
        .flip_y = false,
    };

    // map.dump(tiles);

    // Now go through all tiles and stitch them up

    var x: usize = 1;
    while (x < map.width) : (x += 1) {
        const prev = map.tiles[0][x - 1].?;
        var pdir = prev.orientation.sub(.east);
        if (prev.flip_y)
            pdir = pdir.flip();
        std.debug.print("{} {}\n", .{ prev.orientation, pdir });
        const prev_edge = tiles[prev.index].edgeBits(pdir, !prev.flip_y);
        std.debug.print("{b:0>10}\n", .{ prev_edge });

        var index: usize = undefined;
        var dir: Dir = undefined;
        var flip: bool = undefined;

        outer: for (tiles) |t0, i| {
            if (prev.index == i) continue;

            for (dirs) |d| {
                for (flips) |f| {
                    const e0 = t0.edgeBits(d, f);
                    if (e0 == prev_edge) {
                        index = i;
                        dir = d;
                        flip = f;
                        break :outer;
                    }
                }
            }
        } else {
            unreachable;
        }

        map.tiles[0][x] = PlacedTile{
            .index = index,
            .orientation = .north,
            .flip_x = false,
            .flip_y = false,
        };
        map.dump(tiles);

    }

    // std.debug.print("{}\n", .{ Dir.west.sub(.south).flip() });

    // std.debug.print("{} {} {} {} {}\n", .{ corner, tiles[corner].overlapping[0], tiles[corner].overlapping[1], tiles[corner].overlapping[2], tiles[corner].overlapping[3] });
}


