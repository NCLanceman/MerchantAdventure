//Game.zig
//Game logic goes here

const std = @import("std");
const world = @import("world.zig");
const character = @import("character.zig");
const utils = @import("utils.zig");

const stdout = std.io.getStdOut().writer();

//game loop
//Get to town
//Introduce player to town
//Start the Market Cycle
//Sell for three days
//Attempt to leave
//Select new destination
//Load new town

pub fn dayLoop(map: *world.WorldMap, PC: *character.Character, roller: *utils.Roller) !void {
    //Welcome message
    try stdout.print("Welcome to {s}!\n", .{map.currentLocation.name});
    try world.Calendar.printDateSimple();
    try stdout.print("The markets of {s} await.\n\n", .{map.currentLocation.name});

    //Stay for three days
    var days: u16 = 0;
    while (days < 3) : (days += 1) {
        try merchantLoop(PC, roller);
        try stdout.print("Another day passes.\n", .{});
        world.Calendar.addDay(1);
    }
    try world.Calendar.printDateSimple();
    try stdout.print("It is time to go.\n", .{});
    try stdout.print("Select Destination: \n", .{});
    try map.selectNextDestination();
    world.Calendar.addDay(days);
    try stdout.print("Welcome to {s}!\n", .{map.currentLocation.name});
}

pub fn merchantLoop(PC: *character.Character, roller: *utils.Roller) !void {
    //Choose to cajole or persuade.
    //Roll twice for each section of day
    //If successful, get gold
    //If unsuccessful, tread water or lose money
    var selectionMade: bool = false;
    var selection: u8 = undefined;
    var skill: u8 = undefined;
    var earnings: i16 = undefined;

    try stdout.print(
        \\Choose your approach for the day:
        \\1. Cajole [Skill {}] 
        \\2. Persuade [Skill {}]
    , .{ PC.cajole, PC.persuade });

    while (!selectionMade) {
        selection = try utils.askNum();
        if (selection > 2) {
            try stdout.print("Invalid Selection. Please Try Again.", .{});
        } else {
            selectionMade = true;
        }
    }

    switch (selection) {
        1 => skill = @intCast(PC.cajole),
        2 => skill = @intCast(PC.persuade),
        else => unreachable,
    }

    try stdout.print("Testing your luck in the markets...\n", .{});

    //Roll under skill to win, is possible to lose money
    roller.reset();
    var roll: i16 = @intCast(roller.dieThrow(1, 20));
    try stdout.print("Rolling {} against Skill {}...\n", .{ roll, skill });
    earnings = (skill - roll) * 2;
    try stdout.print("Earnings for this day are {}...\n", .{earnings});
    PC.gold += earnings;
    try stdout.print("Current Gold is {}...\n", .{PC.gold});
}
