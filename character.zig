const std = @import("std");
const utils = @import("utils.zig");

const stdout = std.io.getStdOut().writer();

pub const Character = struct {
    name: [:0]const u8 = "Merchant",
    xp: u8 = 0,
    hp: u8 = 10,
    gold: u16 = 100,

    //basic stats
    //Physical
    st: u8 = undefined,
    dx: u8 = undefined,
    //Mental
    in: u8 = undefined,
    pe: u8 = undefined,
    //Spiritual
    ch: u8 = undefined,
    wp: u8 = undefined,

    //derived stats
    health: u8 = undefined,
    insight: u8 = undefined,
    bravery: u8 = undefined,

    //skills
    melee: u8 = 0,
    ranged: u8 = 0,
    unarmed: u8 = 0,
    appraisal: u8 = 0,
    //culture: u8,
    navigation: u8 = 0,
    command: u8 = 0,
    tactics: u8 = 0,
    persuade: u8 = 0,
    cajole: u8 = 0,

    pub fn init(self: *Character, roller: *utils.Roller) void {
        self.name = "Merchant";
        self.initStats(roller);
    }

    fn initStats(self: *Character, roller: *utils.Roller) void {
        self.st = roller.dieThrow(2, 6);
        self.dx = roller.dieThrow(2, 6);
        self.in = roller.dieThrow(2, 6);
        self.pe = roller.dieThrow(2, 6);
        self.ch = roller.dieThrow(2, 6);
        self.wp = roller.dieThrow(2, 6);
    }

    pub fn deriveStats(self: *Character) void {
        self.melee = self.st + self.dx;
        self.ranged = self.st + self.pe;
        self.unarmed = self.st + self.wp;
        self.appraisal = self.in + self.pe;
        //TODO: Impliment Regional Cultures
        //self.culture = self.pe + self.ch;
        self.navigation = self.in + self.pe;
        self.command = self.pe + self.wp;
        self.tactics = self.in + self.wp;
        self.persuade = self.ch + self.in;
        self.cajole = self.ch + self.st;
    }

    pub fn printCharacterSheet(self: *Character) !void {
        try stdout.print(
            \\Name: {s}
            \\HP: {}
            \\XP: {}
            \\
            \\Stats: 
            \\ST: {}, DX: {}, IN: {}
            \\PE: {}, CH: {}, WP: {}
            \\
            \\Skills: 
            \\-Combat
            \\--melee {}, ranged {}, unarmed{}
            \\-Cultural
            \\--appraisal {}, culture N/A
            \\-Officer
            \\--navigation {}, command {}, tactics {}
            \\-Social
            \\--persuade {}, cajole {}
            \\
        , .{ self.name, self.hp, self.xp, self.st, self.dx, self.in, self.pe, self.ch, self.wp, self.melee, self.ranged, self.unarmed, self.appraisal, self.navigation, self.command, self.tactics, self.persuade, self.cajole });
    }
};
