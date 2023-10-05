//Game.zig
//Game logic goes here

const std = @import("std");
const world = @import("world.zig");
const character = @import("character.zig");
const utils = @import("utils.zig");

const stdout = std.io.getStdOut().writer();

pub const GameState = struct {
    player: character.Character,
    party: [20]character.Character,
    date: u8,
    time: world.TimeOfDay,
    //TODO: Add a way to track location
};

//game loop
//Get to town
//Introduce player to town
//Start the Market Cycle
//Sell for three days
//Attempt to leave
//Select new destination
//Load new town

pub fn dayLoop(map: *world.WorldMap, PC: *character.Character, roller: *utils.Roller) !void {
    var nextConnection: *const world.Connection = undefined;

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
    //try map.selectNextDestination();
    nextConnection = try map.selectNextDestination();
    try travelLoop(PC, nextConnection, roller);
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

pub fn travelLoop(PC: *character.Character, Connection: *const world.Connection, roller: *utils.Roller) !void {
    //Every day of travel, roll to see if a hazard occurs
    //Simple: If hazard occurs, roll
    //Complex: Move into the battle system (TODO)
    const difficulty: i8 = Connection.terrain.getDC();
    var result: i16 = 0;
    var travelDays: u16 = Connection.distance;

    while (travelDays > 0) : (travelDays -= 1) {
        try stdout.print("Day {} of Travel of an expected {} trip...", .{ travelDays, Connection.dest });
        result = (@as(i16, roller.dieThrow(1, 20)) + difficulty);
        if (result < PC.unarmed) {
            try stdout.print("Hazard Check failed. Add combat check here.\n", .{});
        } else {
            try stdout.print("Hazard Check passed.\n", .{});
        }
    }
    try stdout.print("Checks passed! You've arrived!", .{});
}
