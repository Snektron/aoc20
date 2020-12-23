const std = @import("std");
const aoc = @import("aoc.zig");

const Link = struct {
    next: u32,
};

fn move(current: u32, cups: []Link) u32 {
    const i = current - 1;
    var scratch: [4]u32 = undefined;
    for (scratch) |*x, j| {
        x.* = if (j == 0) cups[i].next else cups[scratch[j - 1] - 1].next;
    }

    var dst = if (current == 1) cups.len else current - 1;
    while (std.mem.indexOfScalar(u32, scratch[0 .. 3], @intCast(u32, dst)) != null) {
        dst = if (dst == 1) cups.len else dst - 1;
    }

    cups[scratch[2] - 1].next = cups[dst - 1].next;
    cups[dst - 1].next = scratch[0];
    cups[i].next = scratch[3];

    return scratch[3];
}

fn dump(cups: []const Link) void {
    var i: u32 = 0;
    var j: usize = 0;
    while (j < cups.len) : (j += 1) {
        std.debug.print("{} ", .{ i + 1 });
        i = cups[i].next - 1;
    }
    std.debug.print("\n", .{});
}

fn solution(cups: []const Link) usize {
    var i: u32 = 0;
    var j: usize = 1;
    var sol: usize = 0;
    while (j < cups.len) : (j += 1) {
        sol *= 10;
        sol += cups[i].next;
        i = cups[i].next - 1;
    }

    return sol;
}

fn moveFor(amt: usize, initial: u32, cups: []Link) void {
    var i: usize = 0;
    var current = initial;
    while (i < amt) : (i += 1) {
        current = move(current, cups);
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    // const input = [_]u32{3, 8, 9, 1, 2, 5, 4, 6, 7};
    const input = [_]u32{3, 2, 6, 5, 1, 9, 4, 7, 8};

    {
        const cups = try allocator.alloc(Link, input.len);
        for (input) |x, i| {
            cups[x - 1].next = input[(i + 1) % input.len];
        }

        moveFor(100, input[0], cups);

        aoc.print("Day 23, part 1: {}\n", .{ solution(cups) });
    }

    const cups = try allocator.alloc(Link, 1_000_000);

    for (input) |x, i| {
        cups[x - 1].next = input[(i + 1) % input.len];
    }

    if (cups.len > input.len) {
        var i: u32 = input.len;
        while (i < cups.len) : (i += 1) {
            cups[i].next = (i + 1) % @intCast(u32, cups.len) + 1;
        }

        cups[input[input.len - 1] - 1].next = input.len + 1;
        cups[cups.len - 1].next = input[0];
    }


    moveFor(10_000_000, input[0], cups);
    const a = cups[0].next;
    const b = cups[a - 1].next;

    aoc.print("Day 23, part 2: {}\n", .{ @as(usize, a) * b });
}
