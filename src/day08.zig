const std = @import("std");
const in = @import("input/08.zig");
const aoc = @import("aoc.zig");
const Instruction = in.Instruction;

const State = struct {
    acc: i32,
    i: usize,

    const initial = State{.acc = 0, .i = 0};

    fn next(self: State, input: []const Instruction) State {
        const inst = input[self.i];
        const acc = switch (inst.opcode) {
            .acc => self.acc + inst.arg,
            else => self.acc,
        };

        const i = switch (inst.opcode) {
            .acc, .nop => self.i + 1,
            .jmp => if (inst.arg < 0)
                    self.i - @intCast(u32, -inst.arg)
                else
                    self.i + @intCast(u32, inst.arg),
        };

        return .{.acc = acc, .i = i};
    }
};

const FcfResult = struct {
    start: usize,
    period: usize,
    final_state: State,
};

fn fcf(start: State, input: []const Instruction) FcfResult {
    var t = start.next(input);
    var h = t.next(input);

    while (t.i != h.i) {
        t = t.next(input);
        h = h.next(input).next(input);
    }

    h = start;
    var i: usize = 0;
    while (t.i != h.i) : (i += 1) {
        t = t.next(input);
        h = h.next(input);
    }

    h = h.next(input);
    var j: usize = 1;
    while (t.i != h.i) : (j += 1) {
        h = h.next(input);
    }

    return .{.start = i, .period = j, .final_state = h};
}

pub fn main() void {
    var input = in.input;
    const fcf_result = fcf(State.initial, &input);
    aoc.print("Day 08, part 01: {}\n", .{ fcf_result.final_state.acc });

    const max = fcf_result.start + fcf_result.period;
    var start_state = State.initial;

    for (input) |*inst, i| {
        const orig = inst.opcode;
        inst.opcode = switch (orig) {
            .acc => continue,
            .jmp => .nop,
            .nop => .jmp,
        };

        var state = start_state;
        var j: usize = 0;
        while (j <= max) : (j += 1) {
            state = state.next(&input);

            if (state.i == input.len) {
                aoc.print("Day 08, part 02: {}\n", .{ state.acc });
                return;
            }
        }

        inst.opcode = orig;
    }
}
