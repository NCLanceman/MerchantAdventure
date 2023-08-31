//Game.zig
//Game logic goes here

const std = @import("std");
const world = @import("world.zig");
const character = @import("character.zig");

const stdout = std.io.getStdOut().writer();

//game loop
//Get to town
//Introduce player to town
//Start the Market Cycle
//Sell for three days
//Attempt to leave
//Select new destination
//Load new town

pub fn dayLoop(map: *world.WorldMap) !void {
    //Welcome message
    try stdout.print("Welcome to {s}!\n", .{map.currentLocation.name});
    try world.Calendar.printDateSimple();
    try stdout.print("The markets of {s} await.\n\n", .{map.currentLocation.name});

    //Stay for three days
    var days: u16 = 0;
    while (days < 3) : (days += 1) {
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

pub fn merchantLoop(PC: *character.Character) void{
    //For a given day, roll Appraisal and Persuade
    //Add both and multiply by 5 GP for a result.

    var tradeMod: u8  = PC.cajole + PC.appraisal;
    _ = tradeMod;
}
