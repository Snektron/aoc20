const std = @import("std");

pub fn main() !void {
    var timer = try std.time.Timer.start();
    var total: usize = 0;

    comptime var day = 1;
    inline while (day <= @import("build_options").days) : (day += 1) {
        comptime var buf: [16]u8 = undefined;
        comptime const src = std.fmt.bufPrint(&buf, "day{:0>2}.zig", .{ day }) catch unreachable;
        comptime const main_fn = @import(src).main;

        switch (@typeInfo(@typeInfo(@TypeOf(main_fn)).Fn.return_type.?)) {
            .Void => main_fn(),
            .ErrorUnion => try main_fn(),
            else => unreachable,
        }
        const time = timer.lap();
        std.debug.print("=> {} us\n", .{ time / std.time.ns_per_us });
        total += time;
    }

    std.debug.print("total: {} us\n", .{ total / std.time.ns_per_us });
}
