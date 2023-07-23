const std = @import("std");
const utils = @import("utils.zig");

pub fn main() !void {
    std.debug.print("Hello, {s}!\n", .{"World"});

    //Test: Roll 3d6
    try utils.roller.init();
    var result: u8 = 0;
    var resultSet: [10]u8 = undefined;
    result = utils.roller.roller(3, 6);
    resultSet = utils.roller.retSet();
    std.debug.print("The result of the test is : {}\n", .{result});
    std.debug.print("The set of the dice reads: {any}\n", .{resultSet});
}
