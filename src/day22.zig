const std = @import("std");
const input = @embedFile("input/22.txt");
const aoc = @import("aoc.zig");
const Allocator = std.mem.Allocator;

const Deck = std.fifo.LinearFifo(u8, .Dynamic);

fn parseDecks(allocator: *Allocator) ![2]Deck {
    var it = std.mem.tokenize(input, "\n");
    var a = Deck.init(allocator);
    var b = Deck.init(allocator);

    var player: usize = 0;
    while (it.next()) |line| {
        if (line[0] == 'P') {
            player += 1;
            continue;
        }
        const num = try std.fmt.parseInt(u8, line, 10);

        if (player == 1) {
            try a.writeItem(num);
        } else {
            try b.writeItem(num);
        }
    }

    return [2]Deck{a, b};
}

fn parseDecks2(allocator: *Allocator) ![2][]u8 {
    var it = std.mem.tokenize(input, "\n");
    var a = std.ArrayList(u8).init(allocator);
    var b = std.ArrayList(u8).init(allocator);

    var player: usize = 0;
    while (it.next()) |line| {
        if (line[0] == 'P') {
            player += 1;
            continue;
        }
        const num = try std.fmt.parseInt(u8, line, 10);

        if (player == 1) {
            try a.append(num);
        } else {
            try b.append(num);
        }
    }

    return [2][]u8{ a.toOwnedSlice(), b.toOwnedSlice() };
}


fn score(a: Deck, b: Deck) usize {
    var value: usize = 0;
    var winner = if (a.readableLength() > 0) &a else &b;
    var i = winner.readableLength();
    var j: usize = 0;
    while (i > 0) {
        value += winner.peekItem(j) * i;
        i -= 1;
        j += 1;
    }

    return value;
}

fn combat(allocator: *Allocator) !void {
    const decks = try parseDecks(allocator);
    var a = decks[0];
    var b = decks[1];

    while (a.readableLength() > 0 and b.readableLength() > 0) {
        const x = a.readItem().?;
        const y = b.readItem().?;

        if (x > y) {
            try a.writeItem(x);
            try a.writeItem(y);
        } else {
            try b.writeItem(y);
            try b.writeItem(x);
        }
    }

    aoc.print("Day 22, part 1: {}\n", .{ score(a, b) });
}

const Game = struct {
    a: []u8,
    b: []u8,

    fn eql(l: Game, r: Game) bool {
        return std.mem.eql(u8, l.a, r.a) and std.mem.eql(u8, l.b, r.b);
    }

    fn hash(self: Game) u64 {
        var hasher = std.hash.Wyhash.init(0);

        hasher.update(std.mem.sliceAsBytes(self.a));
        hasher.update(std.mem.sliceAsBytes(self.b));

        return hasher.final();
    }

    fn getWinner(self: Game) ?Player {
        if (self.a.len != 0 and self.b.len != 0)
            return null;
        return if (self.a.len > 0) .a else .b;
    }

    fn getScore(self: Game, winner: Player) usize {
        var win_deck = if (winner == .a) self.a else self.b;
        var final_score: usize = 0;
        for (win_deck) |card, i| {
            final_score += card * (win_deck.len - i);
        }

        return final_score;
    }

    fn dump(self: Game) void {
        std.debug.print("Deck A:", .{});
        for (self.a) |card| std.debug.print(" {}", .{ card });
        std.debug.print("\nDeck B:", .{});
        for (self.b) |card| std.debug.print(" {}", .{ card });
        std.debug.print("\n", .{});
    }

    fn subgame(self: Game, allocator: *Allocator) !Game {
        const a_len = self.a[0];
        const b_len = self.b[0];

        var new = Game{
            .a = try allocator.alloc(u8, a_len),
            .b = try allocator.alloc(u8, b_len),
        };

        std.mem.copy(u8, new.a, self.a[1 .. a_len + 1]);
        std.mem.copy(u8, new.b, self.b[1 .. b_len + 1]);

        return new;
    }

    fn next(self: Game, allocator: *Allocator, winner: Player) !Game {
        const a_len = if (winner == .a) self.a.len + 1 else self.a.len - 1;
        const b_len = if (winner == .a) self.b.len - 1 else self.b.len + 1;

        var new = Game{
            .a = try allocator.alloc(u8, a_len),
            .b = try allocator.alloc(u8, b_len),
        };

        for (self.a[1 ..]) |item, i| {
            new.a[i] = item;
        }

        for (self.b[1 ..]) |item, i| {
            new.b[i] = item;
        }

        if (winner == .a) {
            new.a[new.a.len - 2] = self.a[0];
            new.a[new.a.len - 1] = self.b[0];
        } else {
            new.b[new.b.len - 1] = self.a[0];
            new.b[new.b.len - 2] = self.b[0];
        }

        return new;
    }
};

const Player = enum {
    a,
    b,
};

const SeenGames = std.HashMap(Game, void, Game.hash, Game.eql, std.hash_map.DefaultMaxLoadPercentage);

fn recursiveCombatGame(allocator: *Allocator, start: Game) error{OutOfMemory}!Game {
    // std.debug.print("=== entering subgame ===\n", .{});
    // defer std.debug.print("=== exiting subgame ===\n", .{});

    var seen_games = SeenGames.init(allocator);
    try seen_games.put(start, {});

    var game = start;
    // start.dump();
    // std.debug.print("---\n", .{});

    while (game.a.len > 0 and game.b.len > 0) {
        var winner: Player = if (game.a[0] > game.b[0]) .a else .b;
        if (game.a[0] < game.a.len and game.b[0] < game.b.len) {
            // Recursion time

            const sub = try game.subgame(allocator);
            winner = (try recursiveCombatGame(allocator, sub)).getWinner() orelse .a;
            // std.debug.print("sub-winner: {}\n", .{ winner });
         }

        const next = try game.next(allocator, winner);
        game = next;
        // game.dump();
        // std.debug.print("\n", .{});

        const result = try seen_games.getOrPut(game);
        if (result.found_existing) {
            // std.debug.print("Found infinite loop\n", .{});
            // game.dump();
            return game;
        }
    }

    return game;
}

fn recursiveCombat(allocator: *Allocator) !void {
    const decks = try parseDecks2(allocator);

    var start_game = Game{
        .a = decks[0],
        .b = decks[1],
    };

    const end_game = try recursiveCombatGame(allocator, start_game);
    // end_game.dump();
    const winner = end_game.getWinner() orelse .a;
    aoc.print("Day 22, part 2: {}\n", .{ end_game.getScore(winner) });
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    try combat(allocator);
    try recursiveCombat(allocator);
}
