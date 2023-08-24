const std = @import("std");
const utils = @import("utils.zig");
const world = @import("world.zig");
const character = @import("character.zig");
const game = @import("game.zig");

const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

var roller: utils.Roller = undefined;

pub fn main() !void {
    try roller.init();

    //Test Calendar
    try stdout.print("Testing new calendar...\n", .{});
    try world.Calendar.printDate();

    //Test World
    try stdout.print("Initializing World Map...\n", .{});
    var Map = world.WorldMap{};
    var days: u16 = undefined;
    try Map.init();
    Map.currentLocation = &Map.locations[0];

    try stdout.print("Testing all locations...\n", .{});
    Map.printAllLocations();

    //Testing Connect Selector
    days = try Map.selectNextDestination();
    world.Calendar.addDay(days);
    try world.Calendar.printDate();

    //Testing Character
    var Player = character.Character{};
    Player.init(&roller);
    try Player.printCharacterSheet();
}
