const std = @import("std");

var shuffle = std.rand.DefaultPrng.init(0);

pub const Cell = struct {
    const Self = @This();
    state: bool,
    current: u64,
    cycles: u64,
    pub fn init() Self {
        return .{
            .state = false,
            .current = 0,
            .cycles = 0,
        };
    }
    pub fn invert(self: *Self) void {
        self.state = !self.state;
    }

    pub fn stasis(self: *Self) void {
        self.state = false;
        self.current = 0;
    }

    pub fn grow(self: *Self, amount: u64) void {
        self.current += amount;
        if (self.current > 128) {
            self.state = true;
            self.cycles += 1;
            self.current = 0;
        }
    }
};

pub const Structure = struct {
    const Self = @This();
    const Context = enum(u8) {
        state,
        cycles,
        verbose,
    };
    Cells: []Cell,
    Allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, comptime size: usize) Self {
        var stream = allocator.alloc(Cell, size) catch {
            @panic(" allocation failed ! ");
        };
        return .{
            .Cells = stream,
            .Allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.Allocator.free(self.Cells);
        self.* = undefined;
    }

    fn invert_cell(self: *Self, index: usize) !void {
        if (index >= self.Cells.len) return error.SaturedStructure;
        self.Cells[index].invert();
    }

    pub fn get_cell(self: *Self, index: usize) !*Cell {
        if (index > self.Cells.len) return error.SaturedStructure;
        var safe_cell: Cell = self.Cells[index];
        return &safe_cell;
    }

    pub fn get_cells(self: *Self) []Cell {
        return self.Cells;
    }

    fn shuffle_cells(self: *Self) !void {
        var iterator: usize = 0;
        const size = self.Cells.len;
        while (iterator < size) : (iterator = iterator + 1) {
            var index = shuffle.random().intRangeAtMost(usize, 0, size - 1);

            _ = try self.invert_cell(index);
        }
    }

    pub fn print(self: *Self, context: u8) void {
        std.debug.print("\n\n -{}- ", .{@intToEnum(Context, context)});
        for (self.Cells, 0..) |cell, i| {
            if (i % 10 == 0) {
                std.debug.print(" \n ", .{});
            }

            switch (context) {
                0 => std.debug.print(" {} ", .{@boolToInt(cell.state)}),
                1 => std.debug.print(" {} ", .{cell.cycles - 12297829382473034410}),
                2 => std.debug.print(" [{}]{any}.{any}.{any}", .{ i, cell.cycles - 12297829382473034410, cell.current - 12297829382473034410, cell.state }),
                else => unreachable,
            }
        }
        std.debug.print("\n -{}- \n", .{@intToEnum(Context, context)});
    }

    fn grow_cell(self: *Self, index: usize) !void {
        if (index > self.Cells.len) return error.SaturedStructure;
        self.Cells[index].grow(index);
    }

    pub fn cycle_cells(self: *Self, gens: usize) !void {
        var gen: usize = 0;
        while (gen <= gens) : (gen += 1) {
            var curr: usize = 1;
            while (curr < self.Cells.len - 1) : (curr += 1) {
                var prev = self.Cells[curr - 1];
                var peek = self.Cells[curr + 1];
                if (prev.state and peek.state) {
                    prev.stasis();
                    peek.stasis();
                    _ = try self.grow_cell(curr);
                }
            }

            _ = try self.shuffle_cells();
        }
    }
};

test "Cell" {
    var board = Structure.init(std.testing.allocator, 128);
    defer board.deinit();
    _ = try board.cycle_cells(1000);
    board.print(1);
    var res = board.get_cells();
    std.debug.print("{any}", .{res});
}
