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
    world.Calendar.addTime(3);
    try world.Calendar.printDate();

    //Test World
    try stdout.print("Initializing World Map...\n", .{});
    var Map = world.WorldMap{};
    try Map.init();
    Map.currentLocation = &Map.locations[0];

    //Testing Connect Selector
    //    try Map.selectNextDestination();
    //    try world.Calendar.printDate();

    //Testing Character
    try stdout.print("Testing Character...\n", .{});
    var Player = character.Character{};
    Player.init(&roller);
    try Player.printCharacterSheet();

    //Testing Game Loop
    try game.dayLoop(&Map, &Player, &roller);
}
