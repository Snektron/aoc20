const std = @import("std");
const input = @embedFile("input/18.txt");
const aoc = @import("aoc.zig");

fn atom(p: *aoc.Parser, prec: bool) error{ParseError, Overflow, InvalidCharacter}!usize {
    p.skipSpaces();
    if (p.eat('(')) {
        const x = try expr(p, prec);
        try p.expect(')');
        return x;
    } else {
        return p.int(usize, 10);
    }
}

fn term(p: *aoc.Parser, prec: bool) !usize {
    if (!prec) return try atom(p, prec);

    p.skipSpaces();
    var value = try atom(p, prec);

    while (true) {
        p.skipSpaces();
        if (p.eat('+')) {
            value += try atom(p, prec);
        } else {
            break;
        }
    }

    return value;
}

fn expr(p: *aoc.Parser, prec: bool) !usize {
    p.skipSpaces();
    var value = try term(p, prec);

    while (true) {
        p.skipSpaces();
        if (!prec and p.eat('+')) {
            value += try term(p, prec);
        } else if (p.eat('*')) {
            value *= try term(p, prec);
        } else {
            break;
        }
    }

    return value;
}

pub fn main() !void {
    var it = std.mem.tokenize(input, "\n");
    var part1: usize = 0;
    var part2: usize = 0;
    while (it.next()) |line| {
        var p = aoc.Parser{.input = line};
        part1 += try expr(&p, false);

        p = aoc.Parser{.input = line};
        part2 += try expr(&p, true);
    }
    aoc.print("Day 18, part 1: {}\n", .{ part1 });
    aoc.print("Day 18, part 2: {}\n", .{ part2 });
}
