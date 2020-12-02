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