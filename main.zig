const std = @import("std");
const utils = @import("utils.zig");

const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

const roller = utils.roller;

fn askNum() !u8 {
    //var result: u8 = undefined;

    while (true) {
        try stdout.print("Selection: ", .{});
        const bare_line = try stdin.readUntilDelimiterAlloc(std.heap.page_allocator, '\n', 80);
        defer std.heap.page_allocator.free(bare_line);

        const line = std.mem.trim(u8, bare_line, "\r");

        const result = std.fmt.parseInt(u8, line, 10) catch |err| switch (err) {
            error.Overflow => {
                try stdout.print("Number too large.\n", .{});
                continue;
            },
            error.InvalidCharacter => {
                try stdout.print("Invalid Character.\n", .{});
                continue;
            },
        };
        return result;
    }
}

pub fn main() !void {
    try stdout.print("Hello, {s}!\n", .{"World"});

    //Test: Roll 3d6
    try roller.init();
    var result: u8 = 0;
    var resultSet: [10]u8 = undefined;
    result = roller.dieThrow(3, 6);
    resultSet = roller.retSet();

    try stdout.print("The result of the test is : {}\n", .{result});
    try stdout.print("The set of the dice reads: {any}\n", .{resultSet});

    try stdout.print("Testing reset...\n", .{});
    roller.reset();
    resultSet = roller.retSet();

    try stdout.print("The set of the dice reads: {any}\n", .{resultSet});
    try stdout.print("Rolling again...\n", .{});

    result = roller.dieThrow(5, 10);
    resultSet = roller.retSet();

    try stdout.print("The result of the test is : {}\n", .{result});
    try stdout.print("The set of the dice reads: {any}\n", .{resultSet});
    roller.reset();

    //Test StdIn
    var dieNum: u8 = undefined;
    var dieType: u8 = undefined;

    try stdout.print("Testing Standard In...\n", .{});
    try stdout.print("Select number of dice between 1-10: \n", .{});

    dieNum = try askNum();

    try stdout.print("Select type of dice from 4, 6, 8, 10, 12, or 20: \n", .{});
    dieType = try askNum();

    result = roller.dieThrow(dieNum, dieType);
    resultSet = roller.retSet();

    try stdout.print("The result of the test is : {}\n", .{result});
    try stdout.print("The set of the dice reads: {any}\n", .{resultSet});
}
