//World.zig
//File used to store the main campaign for now, as well as all the methods
//for traversing the world and doing stuff in it.

const std = @import("std");
const utils = @import("utils.zig");

const stdout = std.io.getStdOut().writer();

const WorldErrors = error{ MaxLocationsReached, MaxConnectionsReached, InvalidConnection };

//World Map
//City List: Hatterson, Purple Ridge City, Burgsbergs, Hatanniland,
//Fallen Pine Township, Pextorantal, Silent Rapids, Caninus Megacity 21,
//Tansho-Nagashi City, Fooksalot.
//This list comes from the previous version of the game. Add: city sizes,
//additional villages, caravanserai, waystations, and so on.
//Knock on effects: Regions, biomes, areas.
//Possibly change the map.

//Undeclared World Map
var a: Location = undefined;
var b: Location = undefined;
var c: Location = undefined;
var d: Location = undefined;
var e: Location = undefined;
var f: Location = undefined;
var g: Location = undefined;
var h: Location = undefined;
var i: Location = undefined;
var j: Location = undefined;

pub const WorldMap = struct {
    currentLocation: *const Location = undefined,
    locations: []const Location = undefined,

    const allocator = std.heap.page_allocator;

    pub fn init(self: *WorldMap) !void {
        //self.locations = &[_]Location{ a, b, c, d, e, f, g, h, i, j };
        self.locations = try generateCampaignWorld(allocator);
        self.currentLocation = &self.locations[0];
    }

    //pub fn setLocation(self: *WorldMap, loc: *Location) void {
    //    self.currentLocation = loc;
    //}

    pub fn printLocationBrief(self: *WorldMap) void {
        self.currentLocation.print();
    }

    //TODO: Add method for traversing from the current location to a new one.
    pub fn travelToFirstConn(self: *WorldMap) void {
        generateCampaignWorld();
        self.currentLocation = self.currentLocation.connections[0].dest;
    }

    pub fn printAllLocations(self: *WorldMap) void {
        for (self.locations) |loc| {
            loc.print();
        }
    }

    pub fn selectNextDestination(self: *WorldMap) !void {
        var selectionMade: bool = false;
        var selection: u8 = undefined;

        try stdout.print("Select Next Destination: \n", .{});
        const connect = self.currentLocation.connections.?;
        var idx: u8 = 0;
        while (idx < self.currentLocation.connLimit) : (idx += 1) {
            try stdout.print("{}. {s}\n", .{ idx, connect[idx].dest.name });
        }
        try stdout.print("Make Selection: ", .{});
        while (!selectionMade) {
            selection = try utils.askNum();
            if (selection < self.currentLocation.connLimit) {
                selectionMade = true;
            } else {
                try stdout.print("Invalid Selection, Try Again.\n", .{});
            }
        }

        self.currentLocation = connect[selection].dest;
        try stdout.print("Moving to new Location...\n", .{});
        self.currentLocation.print();
    }
};

pub fn generateCampaignWorld(allocator: std.mem.Allocator) ![]Location {
    a = makeLoc("Hatterston", Biome.temperateForest, 500);
    b = makeLoc("Purple Ridge City", Biome.borealForest, 1200);
    c = makeLoc("Burgsbergs", Biome.tundra, 400);
    d = makeLoc("Hatanniland", Biome.grassland, 700);
    e = makeLoc("Fallen Pine Township", Biome.temperateForest, 600);
    f = makeLoc("Pexorantal", Biome.temperateForest, 1300);
    g = makeLoc("Silent Rapids", Biome.temperateForest, 600);
    h = makeLoc("Caninus Megacity 21", Biome.mediterranian, 1500);
    i = makeLoc("Tansho-Nagashi City", Biome.temperateForest, 1200);
    j = makeLoc("Fooksalot", Biome.mediterranian, 700);

    const a_conn = [_]Connection{makeConnect(&a, &b, 7, Difficulty.marginal)};
    const b_conn = [_]Connection{ makeConnect(&b, &c, 5, Difficulty.ordinary), makeConnect(&b, &d, 10, Difficulty.difficult) };
    const c_conn = [_]Connection{makeConnect(&c, &d, 4, Difficulty.ordinary)};
    const d_conn = [_]Connection{makeConnect(&d, &e, 10, Difficulty.ordinary)};
    const e_conn = [_]Connection{ makeConnect(&e, &f, 3, Difficulty.difficult), makeConnect(&e, &g, 10, Difficulty.marginal) };
    const f_conn = [_]Connection{makeConnect(&f, &g, 4, Difficulty.ordinary)};
    const g_conn = [_]Connection{ makeConnect(&g, &h, 7, Difficulty.difficult), makeConnect(&g, &i, 7, Difficulty.ordinary) };
    const h_conn = [_]Connection{makeConnect(&h, &j, 8, Difficulty.exhausting)};
    const i_conn = [_]Connection{makeConnect(&i, &j, 5, Difficulty.difficult)};

    a.setConnect(a_conn[0..]);
    b.setConnect(b_conn[0..]);
    c.setConnect(c_conn[0..]);
    d.setConnect(d_conn[0..]);
    e.setConnect(e_conn[0..]);
    f.setConnect(f_conn[0..]);
    g.setConnect(g_conn[0..]);
    h.setConnect(h_conn[0..]);
    i.setConnect(i_conn[0..]);

    //Pass World Map back to World Map
    const locArray = [_]Location{ a, b, c, d, e, f, g, h, i, j };

    var copy = try allocator.dupe(Location, &locArray);
    return copy;
}

//Elements of a town:
//Size (population)
//Culture
//Economic type
//Governance
//Connections
pub const Location = struct {
    name: [:0]const u8,
    biome: Biome,
    population: u32,
    connections: ?[10]Connection = null,
    connLimit: u8 = 0,

    pub fn setConnect(self: *Location, connect: []const Connection) void {
        var result: [10]Connection = undefined;
        var idx: u8 = 0;
        while (idx < connect.len) : (idx += 1) {
            result[idx] = connect[idx];
            self.connLimit += 1;
        }
        self.connections = result;
    }

    pub fn print(self: Location) void {
        std.debug.print(
            \\Town Name: {s}
            \\Biome: {s}
            \\Population: {}
            \\Connections: 
        , .{ self.name, self.biome.toText(), self.population });
        if (self.connections != null) {
            const connect = self.connections.?;
            var idx: u8 = 0;
            while (idx < self.connLimit) : (idx += 1) {
                std.debug.print("{s}, ", .{connect[idx].dest.name});
            }
        } else {
            std.debug.print("No Connections.\n", .{});
        }
        std.debug.print("\n\n", .{});
    }
};

pub fn makeLoc(townName: [:0]const u8, biome: Biome, pop: u32) Location {
    return Location{
        .name = townName,
        .biome = biome,
        .population = pop,
    };
}

pub const Connection = struct {
    origin: *const Location,
    dest: *const Location,
    distance: u16,
    terrain: Difficulty,
};

pub fn makeConnect(start: *Location, end: *Location, dist: u16, terrain: Difficulty) Connection {
    return Connection{
        .origin = start,
        .dest = end,
        .distance = dist,
        .terrain = terrain,
    };
}

pub const Difficulty = enum {
    easy,
    marginal,
    ordinary,
    difficult,
    exhausting,
    impossible,
};
//Features
//Seasons and Clock
//The game goes from Early Spring to Winter. Make as much money as you can
//before you go home!
//Knock on effects: Weather?
pub const Biome = enum {
    temperateForest,
    tundra,
    grassland,
    borealForest,
    mediterranian,

    pub fn toText(self: Biome) [:0]const u8 {
        switch (self) {
            Biome.temperateForest => return "Temperate Forest",
            Biome.tundra => return "Tundra",
            Biome.grassland => return "Grassland",
            Biome.borealForest => return "Boreal Forest",
            Biome.mediterranian => return "Mediterranian",
        }
    }
};

pub const Weather = enum {
    Clear,
    Cloudy,
    Rain,
    Thunderstorm,
    Windy,
    Snow,
    Blizzard,
};

pub const Climate = struct {
    var currentWeather: [:0]const u8 = undefined;
    var currentBiome: Biome = undefined;
    const climateRoller = utils.roller;

    pub fn init() void {
        try climateRoller.init();
    }

    pub fn rollWeather() [:0]const u8 {}
};
//Calendar
//For now, impliment the standard Calendar, then attempt something cool.
//YOU CANNOT HAVE A MEANINGFUL CAMPAIGN IF STRICT TIME KEEPING IS NOT OBSERVED.
//Note: A year in this game world is 420 Days, with 15 months of four weeks of
//seven days each. Each season, incidentally is fifteen weeks long.

pub const Calendar = struct {
    var currentDay: u16 = 1;
    var currentYear: u16 = 1240;
    var currentSeason: [:0]const u8 = "Spring";

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

    fn getDay() u16 {
        return (currentDay % 28);
    }

    pub fn addDay(days: u16) void {
        var placeholder: u16 = currentDay + days;
        if (placeholder > 419) {
            //Add years
            currentYear += (placeholder / 420);
            currentDay = (placeholder % 420);
            //Add correct days
        } else {
            currentDay = placeholder;
        }
        currentSeason = getSeason();
    }

    fn getSeason() [:0]const u8 {
        var result: u16 = currentDay / 105;

        switch (result) {
            0 => return "Spring",
            1 => return "Summer",
            2 => return "Fall",
            3 => return "Winter",
            else => unreachable,
        }
    }

    pub fn printDate() !void {
        try stdout.print("Day: {}, Year: {}, Season: {s}\n", .{ currentDay, currentYear, currentSeason });
        try stdout.print("The date is {s} {}, {}\n", .{ getMonth(), getDay(), currentYear });
    }
};
