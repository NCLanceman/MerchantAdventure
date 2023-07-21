const std = @import("std");

pub fn main() void {
    std.debug.print("Hellow, {s}!\n", .{"World"});
}
