const std = @import("std");
const input = @embedFile("input/14.txt");
const aoc = @import("aoc.zig");

fn lazy(mem: *std.AutoHashMap(u36, u36), value: u36, addr: u36, x: u36, bit: u6) error{OutOfMemory}!void {
    if (bit == 36) {
        try mem.put(addr, value);
        return;
    }

    const mask = @as(u36, 1) << bit;
    if (x & mask != 0) {
        try lazy(mem, value, addr & ~mask, x, bit + 1);
        try lazy(mem, value, addr | mask, x, bit + 1);
    } else {
        try lazy(mem, value, addr, x, bit + 1);
    }
}

pub fn main() !void {
    var mem1 = [_]u36{0} ** 100000;
    var mask_ones: u36 = 0;
    var mask_zeroes: u36 = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var mem2 = std.AutoHashMap(u36, u36).init(allocator);

    var it = std.mem.tokenize(input, "\n =[]");
    var sum1: usize = 0;
    while (it.next()) |word| {
        if (std.mem.eql(u8, word, "mask")) {
            const mask_str = it.next().?;
            mask_ones = 0;
            mask_zeroes = 0;

            for (mask_str) |bit, index| {
                switch (bit) {
                    'X' => {},
                    '1' => mask_ones |= @as(u36, 1) << @intCast(u6, 35 - index),
                    '0' => mask_zeroes |= @as(u36, 1) << @intCast(u6, 35 - index),
                    else => unreachable,
                }
            }
        } else {
            const addr = try std.fmt.parseInt(u36, it.next().?, 10);
            const value = try std.fmt.parseInt(u36, it.next().?, 10);
            const value1 = (value | mask_ones) & ~mask_zeroes;
            sum1 -= mem1[addr];
            sum1 += value1;
            mem1[addr] = value1;

            const x = ~(mask_zeroes | mask_ones);
            const start = (addr & mask_zeroes) | mask_ones;

            try lazy(&mem2, value, start, x, 0);
        }
    }

    aoc.print("Day 14, part 1: {}\n", .{ sum1 });

    var sum2: usize = 0;
    var it2 = mem2.iterator();
    while (it2.next()) |entry| {
        sum2 += entry.value;
    }

    aoc.print("Day 14, part 2: {}\n", .{ sum2 });
}
