const std = @import("std");
const input = @embedFile("input.txt");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var list = std.ArrayList(u64).init(allocator);
    defer list.deinit();

    var it = std.mem.split(input, "\n");
    while (it.next()) |line| {
        if (line.len == 0) continue;
        const val = try std.fmt.parseInt(u64, line, 10);
        try list.append(val);
    }

    std.debug.print("Part 1\n", .{});
    for (list.items[0 .. list.items.len - 1]) |a, i| {
        for (list.items[i + 1..]) |b| {
            if (a + b == 2020) {
                std.debug.print("{} * {} = {}\n", .{ a, b, a * b });
            }
        }
    }

    std.debug.print("Part 2\n", .{});
    for (list.items[0 .. list.items.len - 2]) |a, i| {
        for (list.items[i + 1 .. list.items.len - 1]) |b, j| {
            for (list.items[j + 1 ..]) |c| {
                if (a + b + c == 2020) {
                    std.debug.print("{} * {} * {} = {}\n", .{ a, b, c, a * b * c });
                }
            }
        }
    }
}
