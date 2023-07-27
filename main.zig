const std = @import("std");
const utils = @import("utils.zig");

const stdout = std.io.getStdOut();
var bw = std.io.bufferedWriter(stdout.writer());
const w = bw.writer();

const stdin = std.io.getStdIn();
var br = std.io.bufferedReader(stdin.reader());
var r = br.reader();

var buffer: [10]u8 = undefined;
var msg: u32 = undefined;

const roller = utils.roller;

fn askNum() !u8 {
    if (try r.readUntilDelimiterOrEof(&buffer, '\n')) |input| {
        return std.fmt.parseInt(u8, input, 10);
    } else {
        return error.InvalidParam;
    }
}

pub fn main() !void {
    try w.print("Hello, {s}!\n", .{"World"});

    //Test: Roll 3d6
    try roller.init();
    var result: u8 = 0;
    var resultSet: [10]u8 = undefined;
    result = roller.roller(3, 6);
    resultSet = roller.retSet();

    try w.print("The result of the test is : {}\n", .{result});
    try bw.flush();
    try w.print("The set of the dice reads: {any}\n", .{resultSet});
    try bw.flush();

    try w.print("Testing reset...\n", .{});
    try bw.flush();
    roller.reset();
    resultSet = roller.retSet();

    try w.print("The set of the dice reads: {any}\n", .{resultSet});
    try bw.flush();
    try w.print("Rolling again...\n", .{});
    try bw.flush();

    result = roller.roller(5, 10);
    resultSet = roller.retSet();

    try w.print("The result of the test is : {}\n", .{result});
    try bw.flush();
    try w.print("The set of the dice reads: {any}\n", .{resultSet});
    try bw.flush();
    roller.reset();

    //Test StdIn
    var dieNum: u8 = undefined;
    var dieType: u8 = undefined;

    try w.print("Testing Standard In...\n", .{});
    try bw.flush();
    try w.print("Select number of dice between 1-10: ", .{});
    try bw.flush();

    dieNum = try askNum();
    buffer = undefined;

    try w.print("Select type of dice from 4, 6, 8, 10, 12, or 20: ", .{});
    try bw.flush();
    dieType = try askNum();
    buffer = undefined;

    result = roller.roller(dieNum, dieType);
    resultSet = roller.retSet();

    try w.print("The result of the test is : {}\n", .{result});
    try bw.flush();
    try w.print("The set of the dice reads: {any}\n", .{resultSet});
    try bw.flush();
}
