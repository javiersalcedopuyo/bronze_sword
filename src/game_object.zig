const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

const print     = @import("std").debug.print;

const Vector2   = raylib.Vector2;
const Drawable  = @import("drawable.zig").Drawable;
const Scene     = @import("scene.zig").Scene;

pub const GameObject = struct
{
    const Self = @This();

    drawable:           Drawable,
    scene:              *Scene,
    bounding_box_size:  Vector2 = .{.x=0, .y=0},

    pub fn new(d: Drawable, s: *Scene) Self
    {
        const bbs = Vector2{.x = @intToFloat(f32, d.texture.width),
                            .y = @intToFloat(f32, d.texture.height)};

        return Self{.drawable = d,
                    .scene = s,
                    .bounding_box_size = bbs};
    }

    pub fn draw(self: *const Self) void
    {
        self.drawable.draw();
    }

    pub fn intersects(self: *const Self, other: Self) bool
    {
        print("🚧 UNIMPLEMENTED: GameObject.intersects", .{});
        _ = self;
        _ = other;
        return false;
    }
};