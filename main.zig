const std = @import("std");
const utils = @import("utils.zig");
const world = @import("world.zig");

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

    //Test Calendar
    try stdout.print("Testing new calendar...\n", .{});
    try world.Calendar.printDate();

    try stdout.print("Adding fifteen days...\n", .{});
    world.Calendar.addDay(15);
    try world.Calendar.printDate();

    try stdout.print("Adding one hundred days...\n", .{});
    world.Calendar.addDay(50);
    try world.Calendar.printDate();

    try stdout.print("Advancing to next season...\n", .{});
    world.Calendar.addDay(105);
    try world.Calendar.printDate();

    try stdout.print("Adding a year...\n", .{});
    world.Calendar.addDay(420);
    try world.Calendar.printDate();

    //Test World

    //const worldLocations = world.generateCampaignWorld();

    try stdout.print("Initializing World Map...\n", .{});
    //var Map = world.WorldMap{ .locations = worldLocations[0..] };
    var Map = world.WorldMap{};
    try Map.init();
    Map.currentLocation = &Map.locations[0];

    try stdout.print("Testing all locations...\n", .{});
    Map.printAllLocations();
}
