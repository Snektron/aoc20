const std = @import("std");
const Allocator = std.mem.Allocator;
const Log2Int = std.math.Log2Int;
const Int = std.meta.Int;

pub fn splitToIntegers(
    comptime T: type,
    allocator: *std.mem.Allocator,
    data: []const u8,
    delims: []const u8
) ![]T {
    var items = std.ArrayList(T).init(allocator);
    errdefer items.deinit();

    var it = std.mem.tokenize(data, delims);
    while (it.next()) |line| {
        const value = try std.fmt.parseInt(T, line, 10);
        try items.append(value);
    }

    return items.toOwnedSlice();
}

fn radix(comptime T: type, comptime bucket_bits: Log2Int(T), shift: Log2Int(T), value: T) Int(.unsigned, bucket_bits) {
    const RadixType = Int(.unsigned, bucket_bits);
    return @intCast(RadixType, (value >> shift) & std.math.maxInt(RadixType));
}

fn partialRadixSort(comptime T: type, comptime bucket_bits: Log2Int(T), shift: Log2Int(T), src: []const T, dst: []T) void {
    std.debug.assert(src.len == dst.len);
    std.debug.assert(bucket_bits > 0);
    const buckets = 1 << bucket_bits;

    // Calculate the initial number of elements in each bucket
    var prefix = [_]usize{0} ** buckets;
    for (src) |elem| {
        prefix[radix(T, bucket_bits, shift, elem)] += 1;
    }

    // Calculate the offset in `dst` for each bucket
    var accum: usize = 0;
    for (prefix) |*elem| {
        const tmp = accum + elem.*;
        elem.* = accum;
        accum = tmp;
    }

    // Sort the items into the buckets
    for (src) |elem| {
        const bucket = radix(T, bucket_bits, shift, elem);
        dst[prefix[bucket]] = elem;
        prefix[bucket] += 1;
    }
}

pub fn radixSort(comptime T: type, comptime bucket_bits: Log2Int(T), src: []T, tmp: []T) void {
    const steps = @sizeOf(T) * 8 / @as(usize, bucket_bits);
    std.debug.assert(steps * bucket_bits == @sizeOf(T) * 8);

    var i: usize = 0;
    while (i < steps) : (i += 1) {
        const shift = @intCast(Log2Int(T), i * bucket_bits);
        if (i % 2 == 0) {
            partialRadixSort(T, bucket_bits, shift, src, tmp);
        } else {
            partialRadixSort(T, bucket_bits, shift, tmp, src);
        }
    }

    if (steps % 2 == 1) {
        std.mem.copy(T, src, tmp);
    }
}

pub fn radixSortAlloc(comptime T: type, comptime bucket_bits: Log2Int(T), allocator: *Allocator, src: []T) !void {
    const tmp = try allocator.alloc(T, src.len);
    defer allocator.free(tmp);
    radixSort(T, bucket_bits, src, tmp);
}

pub fn print(comptime fmt: []const u8, args: anytype) void {
    std.io.getStdOut().writer().print(fmt, args) catch unreachable;
}

pub fn stripTrailingNewline(text: []const u8) []const u8 {
    if (text.len > 0 and text[text.len - 1] == '\n')
        return text[0 .. text.len - 1];
    return text;
}

pub const Parser = struct {
    input: []const u8,
    offset: usize = 0,

    pub fn peek(self: Parser) ?u8 {
        return if (self.offset < self.input.len)
                self.input[self.offset]
            else
                null;
    }

    pub fn consume(self: *Parser) void {
        self.offset += 1;
    }

    pub fn eat(self: *Parser, c: u8) bool {
        const a = self.peek();
        if (a != null and a.? == c) {
            self.consume();
            return true;
        } else {
            return false;
        }
    }

    pub fn expect(self: *Parser, c: u8) !void {
        if (self.eat(c) == false)
            return error.ParseError;
    }

    pub fn expectStr(self: *Parser, str: []const u8) !void {
        for (str) |c| {
            try self.expect(c);
        }
    }

    pub fn skipSpaces(self: *Parser) void {
        while (self.peek()) |c| {
            switch (c) {
                ' ' => self.consume(),
                else => break,
            }
        }
    }

    pub fn word(self: *Parser) ![]const u8 {
        const start = self.offset;
        while (self.peek()) |c| {
            switch (c) {
                'a'...'z','A'...'Z' => self.consume(),
                else => break,
            }
        }

        const end = self.offset;
        if (end - start == 0) {
            return error.ParseError;
        }

        return self.input[start .. end];
    }

    pub fn expectWord(self: *Parser, expected: []const u8) !void {
        const actual = self.word();
        if (!std.mem.eql(u8, actual, expected)) {
            return error.ParseError;
        }
    }

    pub fn int(self: *Parser, comptime T: type, base: u8) !T {
        const start = self.offset;
        while (self.peek()) |c| {
            switch (c) {
                '0'...'9' => self.consume(),
                else => break,
            }
        }

        const end = self.offset;
        if (end - start == 0) {
            return error.ParseError;
        }

        return try std.fmt.parseInt(u8, self.input[start .. end], base);
    }

    pub fn bagColor(self: *Parser) ![]const u8 {
        const start = self.offset;
        _ = try self.word();
        _ = self.skipSpaces();
        _ = try self.word();

        const end = self.offset;
        if (end - start < 3) { // need at least something like 'a b'
            return error.ParseError;
        }
        return self.input[start .. end];
    }
};