const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});

    const mode = b.standardReleaseOptions();

    comptime var day: usize = 1;
    inline while (day <= 3) : (day += 1) {
        const exe_name = std.fmt.allocPrint(b.allocator, "day{:0>2}", .{ day }) catch unreachable;
        const run_step_name = std.fmt.allocPrint(b.allocator, "run-day{:0>2}", .{ day }) catch unreachable;
        const src = std.fmt.allocPrint(b.allocator, "src/day{:0>2}.zig", .{ day }) catch unreachable;
        const desc = std.fmt.allocPrint(b.allocator, "Run day {:0>2}", .{ day }) catch unreachable;

        const exe = b.addExecutable(exe_name, src);
        exe.setTarget(target);
        exe.setBuildMode(mode);

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step(run_step_name, desc);
        run_step.dependOn(&run_cmd.step);
    }
}
