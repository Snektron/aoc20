const std = @import("std");
const input = @embedFile("input/21.txt");
const aoc = @import("aoc.zig");
const Allocator = std.mem.Allocator;

const Food = struct {
    ingredients: [][]const u8,
    allergens: [][]const u8,

    fn parse(allocator: *Allocator, text: []const u8) !Food {
        var items = std.ArrayList([]const u8).init(allocator);
        var it = std.mem.tokenize(text, " (),");

        var self: Food = undefined;

        while (it.next()) |item| {
            if (std.mem.eql(u8, item, "contains")) {
                self.ingredients = items.toOwnedSlice();
                continue;
            }

            try items.append(item);
        }

        self.allergens = items.toOwnedSlice();

        return self;
    }
};

fn parseInput(allocator: *Allocator) ![]Food {
    var foods = std.ArrayList(Food).init(allocator);
    var it = std.mem.tokenize(input, "\n");
    while (it.next()) |line| {
        try foods.append(try Food.parse(allocator, line));
    }

    return foods.toOwnedSlice();
}

const Assignment = struct {
    ingredient: []const u8,
    allergen: []const u8,

    fn cmp(ctx: void, a: Assignment, b: Assignment) bool {
        return std.mem.order(u8, a.allergen, b.allergen) == .lt;
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const foods = try parseInput(allocator);

    var allergen_to_id = std.StringHashMap(u3).init(allocator);
    var ingredient_to_id = std.StringHashMap(u8).init(allocator);
    var ingredient_count = std.StringHashMap(u8).init(allocator);

    for (foods) |f| {
        for (f.allergens) |a| {
            const id = allergen_to_id.count();
            const result = try allergen_to_id.getOrPut(a);
            if (!result.found_existing) {
                result.entry.value = @intCast(u3, id);
            }
        }

        for (f.ingredients) |i|{
            const id = ingredient_to_id.count();
            const result = try ingredient_to_id.getOrPut(i);
            if (!result.found_existing) {
                result.entry.value = @intCast(u8, id);
            }

            const result2 = try ingredient_count.getOrPut(i);
            if (result2.found_existing) {
                result2.entry.value += 1;
            } else {
                result2.entry.value = 1;
            }
        }
    }

    var masks = std.StringHashMap(u256).init(allocator);

    var ita = allergen_to_id.iterator();
    var mask: u256 = 0;
    while (ita.next()) |e0| {
        const a = e0.key;

        var amask = (@as(u256, 1) << @intCast(u8, ingredient_to_id.count())) - 1;

        for (foods) |f| {
            for (f.allergens) |a0| {
                if (std.mem.eql(u8, a, a0)) break;
            } else continue;

            var imask: u256 = 0;
            for (f.ingredients) |i| {
                const id = ingredient_to_id.get(i).?;
                imask |= @as(u256, 1) << id;
            }

            amask &= imask;
        }

        try masks.put(a, amask);
        mask |= amask;
    }

    var it = ingredient_to_id.iterator();
    var part1: usize = 0;
    var n: usize = 0;
    while (it.next()) |e| {
        const id = e.value;
        const count = ingredient_count.get(e.key).?;
        const imask = @as(u256, 1) << id;
        if (imask & mask == 0) {
            part1 += count;
        } else {
            n += 1;
        }
    }

    aoc.print("Day 21, part 1: {}\n", .{ part1 });

    var d = std.ArrayList(Assignment).init(allocator);

    var i: usize = 0;
    while (i < n) : (i += 1) {
        var m: u256 = undefined;
        const a = blk: {
            var itm = masks.iterator();
            while (itm.next()) |e| {
                if (@popCount(u256, e.value) == 1) {
                    m = e.value;
                    break :blk e.key;
                }
            }

            unreachable;
        };

        const j = @ctz(u256, m);

        var iti = ingredient_to_id.iterator();
        const ing = while (iti.next()) |e| {
            if (e.value == j) break e.key;
        } else unreachable;

        try d.append(.{.ingredient = ing, .allergen = a });

        var itm = masks.iterator();
        while (itm.next()) |e| {
            e.value &= ~m;
        }
    }

    std.sort.sort(Assignment, d.items, {}, Assignment.cmp);

    aoc.print("Day 21, part 2: ", .{});
    for (d.items) |asg, j| {
        if (j != 0) std.debug.print(",", .{});
        aoc.print("{}", .{asg.ingredient});
    }
    aoc.print("\n", .{});
}
