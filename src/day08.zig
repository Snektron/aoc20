const std = @import("std");
const input = @import("input/08.zig").input;
const aoc = @import("aoc.zig");

const RunResult = struct {
    terminates: bool,
    acc: i32,
};

fn run(override: ?usize) RunResult {
    var seen = [_]bool{false} ** input.len;

    var i: usize = 0;
    var acc: i32 = 0;
    while (!seen[i]) {
        seen[i] = true;
        var inst = input[i];
        if (override != null and override.? == i) {
            inst.opcode = switch (inst.opcode) {
                .acc => unreachable,
                .nop => .jmp,
                .jmp => .nop,
            };
        }

        switch (inst.opcode) {
            .acc => { acc += inst.arg; i += 1; },
            .nop => i += 1,
            .jmp => if (inst.arg < 0) {
                i -= @intCast(u32, -inst.arg);
            } else {
                i += @intCast(u32, inst.arg);
            },
        }

        if (i == input.len) {
            return .{
                .terminates = true,
                .acc = acc,
            };
        }
    }

    return .{
        .terminates = false,
        .acc = acc,
    };
}

pub fn main() void {
    aoc.print("Day 08, part 01: {}\n", .{ run(null).acc });

    for (input) |inst, i| {
        if (inst.opcode == .acc) continue;

        const result = run(i);
        if (result.terminates) {
            aoc.print("Day 08, part 02: {}\n", .{ result.acc });
            break;
        }
    }
}
