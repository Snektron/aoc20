const std = @import("std");
const input = @embedFile("input/20.txt");
const aoc = @import("aoc.zig");
const Allocator = std.mem.Allocator;

const Dir = enum(u2) {
    north,
    east,
    south,
    west,

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

const dirs = [_]Dir{.north, .east, .south, .west};

const Tile = struct {
    const width = 10;
    const height = 10;

    id: usize,
    cells: [height][width]bool,

    fn check(self: Tile, x: usize, y: usize) bool {
        return self.cells[y][x];
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

    fn edgeBits(self: Tile, edge: Dir) u10 {
        var bits: u10 = 0;

        switch (edge) {
            .north => for (self.cells[0]) |x, i| {
                if (x) bits |= @as(u10, 1) << @intCast(u4, i);
            },
            .east => for (self.cells[0]) |_, i| {
                if (self.cells[i][9]) bits |= @as(u10, 1) << @intCast(u4, i);
            },
            .south => for (self.cells[9]) |x, i| {
                if (x) bits |= @as(u10, 1) << @intCast(u4, i);
            },
            .west => for (self.cells[0]) |_, i| {
                if (self.cells[i][0]) bits |= @as(u10, 1) << @intCast(u4, i);
            },
        }

        if (edge == .south or edge == .west) bits = @bitReverse(u10, bits);

        return bits;
    }

    fn parse(text: []const u8) !Tile {
        var it = std.mem.tokenize(text, " \n:");
        _ = it.next().?; // 'Tile'

        var self = Tile{
            .id = try std.fmt.parseInt(usize, it.next().?, 10),
            .cells = undefined,
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

fn toAbsoluteEdge(orientation: Dir, edge: Dir) Dir {
    return edge.sub(orientation);
}

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
    dir: Dir,
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
                        std.debug.print("{c}", .{ self.getTilePart(x, y, xt, yt, tiles) });
                    }

                    std.debug.print(" ", .{});
                }
                std.debug.print("\n", .{});
            }
            std.debug.print("\n", .{});
        }
    }

    fn getTilePart(self: TileMap, tx: usize, ty: usize, x: usize, y: usize, tiles: []Tile) u8 {
        const t = self.tiles[ty][tx] orelse return '-';

        var x0 = x;
        var y0 = y;

        if (t.flip_x) x0 = 9 - x0;
        if (t.flip_y) y0 = 9 - y0;

        var x1: usize = undefined;
        var y1: usize = undefined;

        switch (t.dir) {
            .north => { x1 = x0; y1 = y0; },
            .east => { x1 = y0; y1 = 9 - x0; },
            .south => { x1 = 9 - x0 ; y1 = 9 - y0; },
            .west => { x1 = 9 - y0 ; y1 = x0; },
        }

        return if (tiles[t.index].check(x1, y1)) '#' else '.';
    }

    fn render(self: TileMap, tiles: []Tile) [8 * max_height][8 * max_width]u8 {
        var result: [8 * max_height][8 * max_width]u8 = undefined;

        var y: usize = 0;
        while (y < self.height) : (y += 1) {
            var yt: usize = 0;
            while (yt < 8) : (yt += 1) {
                var x: usize = 0;
                while (x < self.width) : (x += 1) {
                    var xt: usize = 0;
                    while (xt < 8) : (xt += 1) {
                        const c = self.getTilePart(x, y, xt + 1, yt + 1, tiles);
                        result[y * 8 + yt][x * 8 + xt] = c;
                    }
                }
            }
        }

        return result;
    }
};

fn fixupRow(row: usize, map: *TileMap, tiles: []Tile) void {
    var x: usize = 1;
    while (x < map.width) : (x += 1) {
        const prev = map.tiles[row][x - 1].?;
        var prev_edge = toAbsoluteEdge(prev.dir, .east).add(if (prev.flip_x) .south else .north);
        var prev_bits = tiles[prev.index].edgeBits(prev_edge);
        if (prev.flip_y != prev.flip_x)
            prev_bits = @bitReverse(u10, prev_bits);

        var flip = false;
        var dir: Dir = undefined;
        const i = blk: for (tiles) |t, i| {
            if (i == prev.index) continue;
            for (dirs) |d| {
                const e = t.edgeBits(d);
                dir = d;
                if (e == prev_bits) {
                    flip = true;
                    break :blk i;
                } else if (e == @bitReverse(u10, prev_bits)) {
                    break :blk i;
                }
            }
        } else unreachable;

        map.tiles[row][x] = PlacedTile{
            .index = i,
            .dir = Dir.west.sub(dir),
            .flip_x = false,
            .flip_y = flip
        };
    }
}

fn rotate(comptime z: usize, arr: *[z][z]u8) void {
    var tmp: [z][z]u8 = undefined;
    for (arr) |row, y| {
        for (row) |c, x| {
            tmp[z - x - 1][y] = c;
        }
    }

    std.mem.copy([z]u8, arr, &tmp);
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const tiles = try parseTiles(allocator);

    var overlap: [4]bool = undefined;
    const corner = for (tiles) |t0, i| {
        var overlaps: usize = 0;
        std.mem.set(bool, &overlap, false);

        for (tiles) |t1, j| {
            if (i == j) continue;
            for (dirs) |d0| {
                for (dirs) |d1| {
                    const e0 = t0.edgeBits(d0);
                    const e1 = t1.edgeBits(d1);
                    if (e0 == e1 or e0 == @bitReverse(u10, e1)) {
                        overlaps += 1;
                        overlap[@enumToInt(d0)] = true;
                    }
                }
            }
        }

        if (overlaps == 2) break i;
    } else unreachable;

    const fd = for (dirs) |d, i| {
        if (overlap[(i + 3) % 4] and overlap[i]) break d;
    } else unreachable;

    var map = TileMap.init(12, 12);
    map.tiles[0][0] = PlacedTile{
        .index = corner,
        .dir = fd,
        .flip_x = false,
        .flip_y = false,
    };

    fixupRow(0, &map, tiles);

    var y: usize = 1;
    while (y < map.height) : (y += 1) {
        const prev = map.tiles[y - 1 ][0].?;
        var prev_edge = toAbsoluteEdge(prev.dir, .south);
        var prev_bits = tiles[prev.index].edgeBits(prev_edge);
        if (prev.flip_x)
            prev_bits = @bitReverse(u10, prev_bits);

        var flip = false;
        var dir: Dir = undefined;
        const i = blk: for (tiles) |t, i| {
            if (i == prev.index) continue;
            for (dirs) |d| {
                const e = t.edgeBits(d);
                dir = d;
                if (e == prev_bits) {
                    flip = true;
                    break :blk i;
                } else if (e == @bitReverse(u10, prev_bits)) {
                    break :blk i;
                }
            }
        } else unreachable;

        map.tiles[y][0] = PlacedTile{
            .index = i,
            .dir = Dir.north.sub(dir),
            .flip_x = flip,
            .flip_y = false
        };

        fixupRow(y, &map, tiles);
    }

    // map.dump(tiles);

    var m = map.render(tiles);

    // for (m) |row| {
    //     for (row) |c| std.debug.print("{c}", .{c});
    //     std.debug.print("\n", .{});
    // }

    const sea_monster = [_][]const u8{
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   ",
    };

    const xend = m[0].len - sea_monster[0].len;
    const yend = m.len - sea_monster.len;

    var r: usize = 0;
    while (r < 4) : (r += 1) {
        // for (m) |row| {
        //     for (row) |c| std.debug.print("{c}", .{c});
        //     std.debug.print("\n", .{});
        // }

        var monster_tiles = [_][96]bool{ [_]bool{false} ** 96 } ** 96;
        var total_monster_tiles: usize = 0;

        var monsters: usize = 0;
        var my: usize = 0;
        while (my < yend) : (my += 1) {
            var mx: usize = 0;

            while (mx < xend) : (mx += 1) {
                const is_monster = blk: for (sea_monster) |row, sy| {
                    for (row) |c, sx| {
                        if (c == ' ') continue;
                        if (m[my + sy][mx + sx] != '#') break :blk false;
                    }
                } else true;
                monsters += @boolToInt(is_monster);

                if (is_monster) {
                    for (sea_monster) |row, sy| {
                        for (row) |c, sx| {
                            if (c == ' ') continue;
                            if (!monster_tiles[my + sy][mx + sx]) {
                                total_monster_tiles += 1;
                            }

                            monster_tiles[my + sy][mx + sx] = true;
                        }
                    }
                }
            }
        }

        if (monsters > 0) {
            var total_tiles: usize = 0;

           for (m) |row| {
                for (row) |c| {
                    if (c == '#') total_tiles += 1;
                }
            }

            std.debug.print("{}\n", .{ total_tiles - total_monster_tiles });
        }

        // std.debug.print("{}\n", .{ part2 });
        rotate(96, &m);
    }
}
