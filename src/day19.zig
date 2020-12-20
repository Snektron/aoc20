const std = @import("std");
const input = @embedFile("input/19.txt");
const aoc = @import("aoc.zig");

const Rule = union(enum) {
    terminal: u8,
    productions: [][]usize,
};

const Grammar = std.AutoHashMap(usize, Rule);

const Parser = struct {
    grammar: *Grammar,
    msg: []const u8,
    offset: usize,

    fn save(self: Parser) usize {
        return self.offset;
    }

    fn restore(self: *Parser, state: usize) void {
        self.offset = state;
    }
};

fn match(parser: *Parser, rule_id: usize) bool {
    const rule = parser.grammar.get(rule_id).?;
    switch (rule) {
        .terminal => |term| {
            if (parser.offset < parser.msg.len and parser.msg[parser.offset] == term) {
                parser.offset += 1;
                return true;
            }
            return false;
        },
        .productions => |prods| {
            for (prods) |prod| {
                const state = parser.save();
                var i: usize = 0;

                for (prod) |r| {
                    if (!match(parser, r)) break;
                } else {
                //     std.debug.print("match {} ->", .{ rule_id });

                //     for (prod) |r| {
                //         std.debug.print(" {}", .{ r });
                //     }
                //     std.debug.print("\n", .{});

                    return true;
                }
                parser.restore(state);
            }

            return false;
        }
    }
}

fn check(msg: []const u8, grammar: *Grammar) bool {
    var parser = Parser{
        .grammar = grammar,
        .msg = msg,
        .offset = 0,
    };

    return match(&parser, 0) and parser.offset == parser.msg.len;
}

fn check2(msg: []const u8, grammar: *Grammar) bool {
    var parser = Parser{
        .grammar = grammar,
        .msg = msg,
        .offset = 0,
    };

    var i: usize = 0;
    while (match(&parser, 42)) : (i += 1) {}

    var j: usize = 0;
    while (match(&parser, 31)) : (j += 1) {}

    return i > j and j > 0 and parser.offset == parser.msg.len;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var grammar = Grammar.init(allocator);
    var prod = std.ArrayList(usize).init(allocator);
    var prods = std.ArrayList([]usize).init(allocator);

    var line_it = std.mem.split(input, "\n");
    outer: while (line_it.next()) |line| {
        if (line.len == 0) break;

        var it = std.mem.tokenize(line, ": ");
        const start = try std.fmt.parseInt(usize, it.next().?, 10);

        while (it.next()) |item| {
            if (item[0] == '"') {
                try grammar.put(start, .{.terminal = item[1]});
                continue :outer;
            } else if (std.mem.eql(u8, item, "|")) {
                try prods.append(prod.toOwnedSlice());
                continue;
            }

            const nt = try std.fmt.parseInt(usize, item, 10);
            try prod.append(nt);
        }

        try prods.append(prod.toOwnedSlice());
        try grammar.put(start, .{.productions = prods.toOwnedSlice()});
    }

    var part1: usize = 0;
    var part2: usize = 0;
    while (line_it.next()) |msg| {
        if (msg.len == 0) break;
        if (check(msg, &grammar)) part1 += 1;
        if (check2(msg, &grammar)) part2 += 1;
    }

    aoc.print("Day 19, part 1: {}\n", .{ part1 });
    aoc.print("Day 19, part 2: {}\n", .{ part2 });
}
