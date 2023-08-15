//Utils.zig
//File for storing utility functions

const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

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

    pub fn dieThrow(diceNum: u8, diceType: u8) u8 {
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

    pub fn reset() void {
        var i: u8 = 0;

        while (i < diceSet.len) : (i += 1) {
            zeroOut(&diceSet[i]);
        }
    }

    fn zeroOut(x: *u8) void {
        x.* = 0;
    }
};

pub fn askNum() !u8 {
    //var result: u8 = undefined;

    while (true) {
        try stdout.print("Selection: ", .{});
        const bare_line = try stdin.readUntilDelimiterAlloc(std.heap.page_allocator, '\n', 80);
        defer std.heap.page_allocator.free(bare_line);

        const line = std.mem.trim(u8, bare_line, "\r");

        const result = std.fmt.parseInt(u8, line, 10) catch |err| switch (err) {
            error.Overflow => {
                try stdout.print("Number too large.\n", .{});
                continue;
            },
            error.InvalidCharacter => {
                try stdout.print("Invalid Character.\n", .{});
                continue;
            },
        };
        return result;
    }
}
