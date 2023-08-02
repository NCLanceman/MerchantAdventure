//World.zig
//File used to store the main campaign for now, as well as all the methods
//for traversing the world and doing stuff in it.

const std = @import("std");

const stdout = std.io.getStdOut().writer();

//World Map
//City List: Hatterson, Purple Ridge City, Burgsbergs, Hatanniland,
//Fallen Pine Township, Pextorantal, Silent Rapids, Caninus Megacity 21,
//Tansho-Nagashi City, Fooksalot.
//This list comes from the previous version of the game. Add: city sizes,
//additional villages, caravanserai, waystations, and so on.
//Knock on effects: Regions, biomes, areas.
//Possibly change the map.

//Elements of a town:
//Size (population)
//Culture
//Economic type
//Governance
//Connections

//Features
//Seasons and Clock
//The game goes from Early Spring to Winter. Make as much money as you can
//before you go home!
//Knock on effects: Weather?

//Calendar
//For now, impliment the standard Calendar, then attempt something cool.
//YOU CANNOT HAVE A MEANINGFUL CAMPAIGN IF STRICT TIME KEEPING IS NOT OBSERVED.
//Note: A year in this game world is 420 Days, with 15 months of four weeks of
//seven days each. Each season, incidentally is fifteen weeks long.

pub const Calendar = struct {
    var currentDay: u16 = 1;
    var currentYear: u16 = 1240;

    fn getMonth() [:0]const u8 {
        const result = switch ((currentDay / 28) + 1) {
            1 => "Alpha", //Wk 1-4 [Beginning of Spring]
            2 => "Bravo", //Wk 5-8
            3 => "Charlie", //Wk 9-12
            4 => "Delta", //Wk 13-16 //[Beginning of Summer]
            5 => "Echo", //Wk 17-20
            6 => "Foxtrot", //Wk 21-24
            7 => "Golf", //Wk 25-28
            8 => "Hotel", //Wk 29-32 //[Beginning of Fall]
            9 => "India", //Wk 33-36
            10 => "Juliet", //Wk 37-40
            11 => "Kilo", //Wk 41-44
            12 => "Lima", //Wk 45-48 //[Beginning of Winter]
            13 => "Mike", //Wk 49-52
            14 => "November", //Wk 53-56
            15 => "Oscar", //wk 57-60
            else => unreachable,
        };

        return result;
    }

    fn addDay(days: u16) void {
        var placeholder: u16 = currentDay + days;
        if (placeholder > 419) {
            //Add years
            currentYear += (placeholder / 420);
            currentDay += (placeholder % 420);
            //Add correct days
        } else {
            currentDay = placeholder;
        }
    }

    pub fn printDate() !void {
        try stdout.print("{s} {}, {}\n", .{ getMonth(), currentDay, currentYear });
    }
};
