const std = @import("std");
const input = @embedFile("input/07.txt");
const aoc = @import("aoc.zig");

const Edge = struct {
    dst: usize,
    count: usize,
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var total_lines = std.mem.count(u8, input, "\n");

    var color_to_id = std.StringHashMap(u32).init(allocator);
    try color_to_id.ensureCapacity(@intCast(u32, total_lines));

    var graph = try allocator.alloc(std.ArrayListUnmanaged(Edge), total_lines);
    for (graph) |*x| x.* = .{};

    var reverse_graph = try allocator.alloc(std.ArrayListUnmanaged(usize), total_lines);
    for (reverse_graph) |*x| x.* = .{};

    var line_it = std.mem.tokenize(input, "\n");
    while (line_it.next()) |line| {
        var parser = aoc.Parser{.input = line};
        const src = try parser.bagColor();
        const src_id = (try color_to_id.getOrPutValue(src, color_to_id.count())).value;

        try parser.expectStr(" bags contain ");

        if (parser.eat('n')) {
            try parser.expectStr("o other bags.");
            continue;
        }

        while (true) {
            const count = try parser.int(usize, 10);
            parser.skipSpaces();
            const dst = try parser.bagColor();
            const dst_id = (try color_to_id.getOrPutValue(dst, color_to_id.count())).value;

            // std.debug.print("{} ({}) => {} {} ({})\n", .{ src, src_id, count, dst, dst_id });

            try reverse_graph[dst_id].append(allocator, src_id);
            try graph[src_id].append(allocator, .{.dst = dst_id, .count = count});

            if (count == 1) {
                try parser.expectStr(" bag");
            } else {
                try parser.expectStr(" bags");
            }

            if (parser.eat('.')) {
                break;
            }

            try parser.expectStr(", ");
        }
    }

    const start_id = color_to_id.get("shiny gold").?;

    {
        var seen = try allocator.alloc(bool, reverse_graph.len);
        for (seen) |*x| x.* = false;

        var queue = std.ArrayList(usize).init(allocator);
        try queue.append(start_id);
        seen[start_id] = true;
        var count: usize = 0;

        while (queue.popOrNull()) |src| {
            for (reverse_graph[src].items) |dst| {
                if (!seen[dst]) {
                    seen[dst] = true;
                    count += 1;

                    try queue.append(dst);
                }
            }
        }

        aoc.print("Day 07, part 1: {}\n", .{ count });
    }

    {
        const Item = struct {
            multiplier: usize,
            id: usize,
        };

        var stack = std.ArrayList(Item).init(allocator);
        try stack.append(.{.multiplier = 1, .id = start_id});
        var count: usize = 0;

        while (stack.popOrNull()) |src| {
            for (graph[src.id].items) |dst| {
                count += dst.count * src.multiplier;
                try stack.append(.{
                    .multiplier = src.multiplier * dst.count,
                    .id = dst.dst,
                });
            }
        }

        aoc.print("Day 07, part 2: {}\n", .{ count });
    }
}
