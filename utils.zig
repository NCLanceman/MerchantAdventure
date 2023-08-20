//Utils.zig
//File for storing utility functions

const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

pub const Roller = struct {
    diceSet: [10]u8 = undefined,
    randGen: std.rand.Xoshiro256 = undefined,

    pub fn init(self: *Roller) !void {
        self.randGen = std.rand.DefaultPrng.init(blk: {
            var seed: u64 = undefined;
            try std.os.getrandom(std.mem.asBytes(&seed));
            break :blk seed;
        });
    }

    pub fn dieThrow(self: *Roller, diceNum: u8, diceType: u8) u8 {
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
            self.diceSet[i] = self.randGen.random().intRangeAtMost(u8, 1, setDice);
            result += self.diceSet[i];
        }

        return result;
    }

    pub fn retSet(self: *Roller) [10]u8 {
        return self.diceSet;
    }

    pub fn reset(self: *Roller) void {
        var i: u8 = 0;

        while (i < self.diceSet.len) : (i += 1) {
            zeroOut(&self.diceSet[i]);
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
                try stdout.print("Number out of bounds.\n", .{});
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
