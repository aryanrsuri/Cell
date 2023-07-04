const std = @import("std");
const wasm = @import("Cell.zig").wasm;

pub fn main() !void {

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var stream = std.heap.GeneralPurposeAllocator(.{}){};
    var gpa = stream.allocator();
    var structure = wasm(gpa, 100, 4);
    // var structure = cell.Structure.init(gpa, 128);
    // _ = try structure.cycle_cells(1000);
    try stdout.print("{any}\n", .{structure.*});
    try bw.flush();
}
