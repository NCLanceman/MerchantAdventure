//Utils.zig
//File for storing utility functions

const std = @import("std");

pub const roller = struct {
    var diceSet: [10]u8 = undefined;
    var randGen: std.rand.Xoshiro256 = undefined;

    pub fn init() !void {
        randGen = std.rand.DefaultPrng.init(blk: {
            var seed: u64 = undefined;
            try std.os.getrandom(std.mem.asBytes(&seed));
            break :blk seed;
        });
    }

    pub fn roller(diceNum: u8, diceType: u8) u8 {
        var i: u8 = 0;
        var result: u8 = 0;
        var setDice: u8 = undefined;

        switch (diceType) {
            4 => setDice = diceType,
            6 => setDice = diceType,
            8 => setDice = diceType,
            10 => setDice = diceType,
            12 => setDice = diceType,
            20 => setDice = diceType,
            else => unreachable,
        }

        while (i < diceNum) : (i += 1) {
            diceSet[i] = randGen.random().intRangeAtMost(u8, 1, setDice);
            result += diceSet[i];
        }

        return result;
    }

    pub fn retSet() [10]u8 {
        return diceSet;
    }
};
