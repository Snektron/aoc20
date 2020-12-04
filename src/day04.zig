const std = @import("std");
const input = @embedFile("input/04.txt");
const aoc = @import("aoc.zig");

const required_fields = [_][]const u8{
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
    "cid",
};

const eye_colors = [_][]const u8{
    "amb", "blu", "brn", "gry", "grn", "hzl", "oth"
};

fn isHex(c: u8) bool {
    return (c >= 'a' and c <= 'f') or (c >= '0' and c <= '9');
}

pub fn main() !void {
    var it = std.mem.split(input, "\n\n");
    var present: usize = 0;
    var valid: usize = 0;

    while (it.next()) |passport| {
        var field_it = std.mem.tokenize(passport, "\n ");
        var present_fields: [required_fields.len]bool = undefined;
        for (present_fields) |*x| x.* = false;
        var fields_valid = true;

        while (field_it.next()) |field| {
            const colon = std.mem.indexOfScalar(u8, field, ':').?;
            const field_name = field[0 .. colon];
            const field_value = field[colon + 1 ..];

            for (required_fields) |required_field, i| {
                if (!std.mem.eql(u8, field_name, required_field)) {
                    continue;
                }
                present_fields[i] = true;
                break;
            } else {
                return error.InvalidField;
            }

            if (std.mem.eql(u8, field_name, "byr")) {
                const value = try std.fmt.parseInt(usize, field_value, 10);
                if (value < 1920 or value > 2002) {
                    fields_valid = false;
                }
            } else if (std.mem.eql(u8, field_name, "iyr")) {
                const value = try std.fmt.parseInt(usize, field_value, 10);
                if (value < 2010 or value > 2020) {
                    fields_valid = false;
                }
            } else if (std.mem.eql(u8, field_name, "eyr")) {
                const value = try std.fmt.parseInt(usize, field_value, 10);
                if (value < 2020 or value > 2030) {
                    fields_valid = false;
                }
            } else if (std.mem.eql(u8, field_name, "hgt")) {
                if (std.mem.endsWith(u8, field_value, "cm")) {
                    const value = try std.fmt.parseInt(usize, field_value[0 .. field_value.len - 2], 10);
                    if (value < 150 or value > 193) {
                        fields_valid = false;
                    }
                } else if (std.mem.endsWith(u8, field_value, "in")) {
                    const value = try std.fmt.parseInt(usize, field_value[0 .. field_value.len - 2], 10);
                    if (value < 59 or value > 76) {
                        fields_valid = false;
                    }
                } else {
                    fields_valid = false;
                }
            } else if (std.mem.eql(u8, field_name, "hcl")) {
                if (field_value.len != 7 or field_value[0] != '#') {
                    fields_valid = false;
                    continue;
                }

                for (field_value[1..]) |c| {
                    if (!isHex(c)) {
                        fields_valid = false;
                        break;
                    }
                }
            } else if (std.mem.eql(u8, field_name, "ecl")) {
                for (eye_colors) |eye_color| {
                    if (std.mem.eql(u8, eye_color, field_value)) {
                        break;
                    }
                } else {
                    fields_valid = false;
                }
            } else if (std.mem.eql(u8, field_name, "pid")) {
                if (field_value.len != 9) {
                    fields_valid = false;
                    continue;
                }

                for (field_value[1..]) |c| {
                    if (c < '0' or c > '9') {
                        fields_valid = false;
                        break;
                    }
                }
            }
        }

        for (present_fields[0 .. present_fields.len - 1]) |x, i| {
            if (!x) {
                break;
            }
        } else {
            present += 1;
            valid += @boolToInt(fields_valid);
        }
    }

    aoc.print("Day 04, part 1: {}\n", .{ present });
    aoc.print("Day 04, part 2: {}\n", .{ valid });
}