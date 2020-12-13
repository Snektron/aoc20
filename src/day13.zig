const std = @import("std");
const input = @embedFile("input/13.txt");
const aoc = @import("aoc.zig");

const Akpb = struct {
    a: usize,
    b: usize,

    fn combine(x: Akpb, y: Akpb) Akpb {
        var k: usize = 0;
        while (k <= y.a) : (k += 1) {
            const c = x.a * k + x.b;
            if (c < y.b) continue;

            if ((c - y.b) % y.a == 0) {
                return .{.a = x.a * y.a, .b = c};
            }
        }

        unreachable;
    }
};

pub fn main() !void {
    var it = std.mem.tokenize(input, ",\n");
    const t0 = try std.fmt.parseInt(usize, it.next().?, 10);

    var best: ?usize = null;
    var z: ?Akpb = null;
    var b: usize = 0;
    while (it.next()) |bus_id_str| {
        if (std.mem.eql(u8, "x", bus_id_str)) {
            b += 1;
            continue;
        }

        const bus_id = try std.fmt.parseInt(usize, bus_id_str, 10);
        const wait_time = bus_id - t0 % bus_id;

        if (best == null or wait_time < best.? - t0 % best.?) {
            best = bus_id;
        }

        // Hack a positive value for b
        const w = Akpb{.a = bus_id, .b = (bus_id * 10 - b) % bus_id };

        if (z == null) {
            z = w;
        } else {
            z = z.?.combine(w);
        }

        b += 1;
    }

    aoc.print("Day 13, part 1: {}\n", .{ best.? * (best.? - t0 % best.?) });
    aoc.print("Day 13, part 2: {}\n", .{ z.?.b });
}
