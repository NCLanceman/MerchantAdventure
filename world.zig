//World.zig
//File used to store the main campaign for now, as well as all the methods
//for traversing the world and doing stuff in it.

const std = @import("std");

//World Map
//City List: Hatterson, Purple Ridge City, Burgsbergs, Hatanniland,
//Fallen Pine Township, Pextorantal, Silent Rapids, Caninus Megacity 21,
//Tansho-Nagashi City, Fooksalot.
//This list comes from the previous version of the game. Add: city sizes,
//additional villages, caravanserai, waystations, and so on.
//Knock on effects: Regions, biomes, areas.
//Possibly change the map.

//Features
//Seasons and Clock
//The game goes from Early Spring to Winter. Make as much money as you can
//before you go home!
//Knock on effects: Weather?
