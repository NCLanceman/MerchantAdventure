const std = @import("std");
const utils = @import("utils.zig");

const reader = std.io.getStdIn().reader();
const writer = std.io.getStdOut().writer();

var buffer: [10]u8 = undefined;

const roller = utils.roller;

pub fn main() !void {
    try writer.print("Hello, {s}!\n", .{"World"});

    //Test: Roll 3d6
    try roller.init();
    var result: u8 = 0;
    var resultSet: [10]u8 = undefined;
    result = roller.roller(3, 6);
    resultSet = roller.retSet();

    try writer.print("The result of the test is : {}\n", .{result});
    try writer.print("The set of the dice reads: {any}\n", .{resultSet});

    try writer.print("Testing reset...\n", .{});
    roller.reset();
    resultSet = roller.retSet();

    try writer.print("The set of the dice reads: {any}\n", .{resultSet});
    try writer.print("Rolling again...\n", .{});

    result = roller.roller(5, 10);
    resultSet = roller.retSet();

    try writer.print("The result of the test is : {}\n", .{result});
    try writer.print("The set of the dice reads: {any}\n", .{resultSet});
    roller.reset();

    //Test StdIn
    var dieNum: u8 = undefined;
    var dieType: u8 = undefined;

    try writer.print("Testing Standard In...\n", .{});
    try writer.print("Select number of dice between 1-10: ", .{});

    if (try reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |input| {
        dieNum = try std.fmt.parseInt(u8, input, 10);
    } else {
        error.InvalidParam;
    }

    try writer.print("Select type of dice from 4, 6, 8, 10, 12, or 20: ", .{});
    if (try reader.readUntilDelimiterOrEof(buffer[0..], '\n')) |input| {
        dieType = try std.fmt.parseInt(u8, input, 10);
    } else {
        error.InvalidParam;
    }

    result = roller.roller(dieNum, dieType);
    resultSet = roller.retSet();

    try writer.print("The result of the test is : {}\n", .{result});
    try writer.print("The set of the dice reads: {any}\n", .{resultSet});
}
