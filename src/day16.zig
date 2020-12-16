const std = @import("std");
const input = @embedFile("input/16.txt");
const aoc = @import("aoc.zig");

const Range = struct {
    lo: usize,
    hi: usize,

    fn inRange(self: Range, value: usize) bool {
        return self.lo <= value and value <= self.hi;
    }
};

const Class = struct {
    name: []const u8,
    a: Range,
    b: Range,

    fn inRange(self: Class, value: usize) bool {
        return self.a.inRange(value) or self.b.inRange(value);
    }
};

const Ticket = struct {
    values: []usize,
};

const Input = struct {
    classes: []Class,
    ticket: Ticket,
    nearby_tickets: []Ticket,
};

fn parseClass(line: []const u8) !Class {
    const name_len = std.mem.indexOfScalar(u8, line, ':').?;
    const name = line[0 .. name_len];
    var it = std.mem.tokenize(line[name_len..], ":- ,");
    const a_lo = try std.fmt.parseInt(usize, it.next().?, 10);
    const a_hi = try std.fmt.parseInt(usize, it.next().?, 10);
    _ = it.next().?; // or
    const b_lo = try std.fmt.parseInt(usize, it.next().?, 10);
    const b_hi = try std.fmt.parseInt(usize, it.next().?, 10);
    return Class{.name = name, .a = .{.lo = a_lo, .hi = a_hi}, .b = .{.lo = b_lo, .hi = b_hi}};
}

fn parseTicket(line: []const u8, allocator: *std.mem.Allocator) !Ticket {
    const n_items = std.mem.count(u8, line, ",") + 1;
    const values = try allocator.alloc(usize, n_items);
    var it = std.mem.tokenize(line, ",");
    var i: usize = 0;
    while (i < n_items) : (i += 1) {
        values[i] = try std.fmt.parseInt(usize, it.next().?, 10);
    }
    return Ticket{.values = values};
}

fn parse(allocator: *std.mem.Allocator) !Input {
    var classes = std.ArrayList(Class).init(allocator);
    var tickets = std.ArrayList(Ticket).init(allocator);

    var lines = std.mem.tokenize(input, "\n");
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "your ticket:"))
            break;

        try classes.append(try parseClass(line));
    }

    const ticket = try parseTicket(lines.next().?, allocator);
    _ = lines.next().?; // nearby tickets:
    while (lines.next()) |line| {
        try tickets.append(try parseTicket(line, allocator));
    }

    return Input{
        .classes = classes.toOwnedSlice(),
        .ticket = ticket,
        .nearby_tickets = tickets.toOwnedSlice(),
    };
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const in = try parse(allocator);

    var applicable_classes = try allocator.alloc(u64, in.ticket.values.len);
    const all_set = (@as(u64, 1) << @intCast(u6, in.ticket.values.len)) - 1;
    std.mem.set(u64, applicable_classes, all_set); // set all as applicable

    var part1: usize = 0;
    var write_index: usize = 0;
    for (in.nearby_tickets) |ticket| {
        var invalid: bool = false;
        for (ticket.values) |value| {
            for (in.classes) |class| {
                if (class.inRange(value)) {
                    break;
                }
            } else {
                part1 += value;
                invalid = true;
            }
        }

        if (invalid) continue;

        for (ticket.values) |value, j| {
            for (in.classes) |class, i| {
                if (!class.inRange(value)) {
                    const bit = @as(u64, 1) << @intCast(u6, i);
                    applicable_classes[j] &= ~bit;
                }
            }
        }
    }

    aoc.print("Day 16, part 1: {}\n", .{ part1 });

    var i: usize = 0;
    var part2: usize = 1;
    while (i < applicable_classes.len) : (i += 1) {
        const j = for (applicable_classes) |classes, k| {
                if (@popCount(u64, classes) == 1) break k;
            } else unreachable;

        const mask = applicable_classes[j];
        const class_index = @ctz(u64, mask);
        const name = in.classes[class_index].name;

        // Mark as used
        for (applicable_classes) |*classes| {
            classes.* &= ~mask;
        }

        if (std.mem.startsWith(u8, name, "departure")) {
            part2 *= in.ticket.values[j];
        }
    }

    aoc.print("Day 16, part 2: {}\n", .{ part2 });
}
