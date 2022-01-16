const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    defer {
        if (gpa.deinit()) {
            @panic("yes: Leak detected.");
        }
    }

    var buf: []u8 = try alloc.alloc(u8, std.mem.page_size);
    std.mem.copy(u8, buf, "y\n");

    const stdout = std.io.getStdOut().writer();
    while (true) {
        try stdout.writeAll(buf);
    }
}
