//Game.zig
//Game logic goes here

const std = @import("std");
const world = @import("world.zig");

//game loop
//Get to town
//Introduce player to town
//Start the Market Cycle
//Sell for three days
//Attempt to leave
//Select new destination
//Load new town

pub fn dayLoop(map: world.WorldMap, calendar: world.Calendar) void {
    //Welcome message
    std.debug.print("Welcome to {s}!\n", .{map.currentLocation.name});
    std.debug.print("The date is: {s}.\n", .{calendar.printDate()});
    std.debug.print("The markets of {s} await.\n\n", .{map.currentLocation.name});

    //Stay for three days
    var days: u16 = 0;
    while (days > 3) : (days += 1) {
        std.debug.print("Another day passes.\n", .{});
        calendar.addDay(1);
    }
    std.debug.print("The date is {s}. It is time to go.", .{calendar.printDate()});
    std.debug.print("Select Destination: \n", .{});
    days = map.selectNextDestination();
    calendar.addDay(days);
    std.debug.print("Welcome to {s}!\n", .{map.currentLocation.name});
}
