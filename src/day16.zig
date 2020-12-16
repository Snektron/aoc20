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

    var total: usize = 0;
    var write_index: usize = 0;
    for (in.nearby_tickets) |ticket| {
        var invalid: bool = false;
        for (ticket.values) |value| {
            for (in.classes) |class| {
                if (class.inRange(value)) {
                    break;
                }
            } else {
                total += value;
                invalid = true;
            }
        }

        if (invalid) {
            in.nearby_tickets[write_index] = in.ticket;
            write_index += 1;
        }
    }

    aoc.print("Day 16, part 1: {}\n", .{ total });
}
