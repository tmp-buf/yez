const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        if (gpa.deinit())
            @panic("yez: Leak detected.");
    }

    const str = "z\n";

    // Page-aligned memory is what brings speed
    var buf: []u8 = try allocator.alloc(u8, std.mem.page_size * 2);

    // Fill buffer with string
    std.mem.copy(u8, buf, str ** (std.mem.page_size * 2 / str.len));

    const stdout = std.io.getStdOut().writer();
    while (true) {
        try stdout.writeAll(buf);
    }
}
