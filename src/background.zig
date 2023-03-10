const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Vector2   = raylib.Vector2;
const Texture   = raylib.Texture;
const Color     = raylib.Color;

const Drawable  = @import("drawable.zig").Drawable;
const Transform = @import("transform.zig").Transform;

pub const Background = struct
{
    const Self = @This();

    drawable: Drawable,

    pub fn new(texture: Texture) Self
    {
        const scale = @intToFloat(f32, raylib.GetScreenHeight()) /
                      @intToFloat(f32, texture.height);

        var drawable = Drawable.new(texture);
        drawable.transform = .{.scale = .{.x=scale, .y=scale}};

        return Background{.drawable = drawable};
    }

    pub fn deinit(self: *Self) void
    {
        self.drawable.deinit();
    }

    pub fn update(self: *Self) void
    {
        // TODO: Move with the player
        _ = self;
    }

    pub fn draw(self: *Self) void
    {
        self.drawable.draw();
    }
};