const std = @import("std");

pub const State = enum(u8) {
    Dead = 0,
    Alive = 255,
};
pub const Cell = struct {
    const Self = @This();
    state: State,

    fn init() Self {
        return .{
            .state = State.Dead,
        };
    }

    fn is_alive(self: *Self) bool {
        return self.state == State.Alive;
    }

    fn invert(self: *Self) void {
        if (self.is_alive()) {
            self.state = State.Dead;
        } else {
            self.state = State.Alive;
        }
    }
};

pub const Board = struct {
    const Self = @This();
    Cells: std.ArrayList(*Cell),
    Allocator: std.mem.Allocator,
    Size: u8 = 64,

    pub fn init(allocator: std.mem.Allocator) !Self {
        var stream = std.ArrayList(*Cell).initCapacity(allocator, 64) catch {
            @panic(" allocation failed ");
        };

        var safe_cell = Cell.init();
        _ = try stream.appendNTimes(&safe_cell, 64);
        return .{
            .Cells = stream,
            .Allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        self.Cells.deinit();
        self.* = undefined;
    }

    pub fn invert_cell(self: *Self, index: usize) void {
        if (index > self.Size - 1) {
            for (self.Cells.items) |safe_cell| {
                safe_cell.invert();
            }
        } else {
            var safe_cell: *Cell = self.Cells.items[index];
            safe_cell.invert();
        }
    }

    pub fn get_cell(self: *Self, index: usize) !*Cell {
        if (index > self.Size) return error.OverSize;
        var safe_cell: *Cell = self.Cells.items[index];
        std.debug.print("\ncolour {}\n", .{@enumToInt(safe_cell.state)});
        return safe_cell;
    }
};

test "nox" {
    var board = try Board.init(std.testing.allocator);
    std.debug.print(" \n Cell 2 {any}\n", .{try board.get_cell(2)});
    defer board.deinit();
    // _ = board.invert_cell(3);
    var result = try board.get_cell(2);
    std.debug.print("\nCell 2 {any} \n", .{result});
}
