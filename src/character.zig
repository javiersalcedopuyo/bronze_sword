const raylib = @cImport({
    @cInclude("raylib.h");
});

const Rectangle = raylib.Rectangle;
const Texture = raylib.Texture;
const Vector2 = raylib.Vector2;

pub const Character = struct
{
    const Self = @This();

    texture:    Texture,
    frames:     []const Rectangle,

    position:   Vector2 = .{ .x=0, .y=0 },
    scale:      Vector2 = .{ .x=1, .y=1 },

    pub fn draw(self: *Self) void
    {
        const src_rect = self.frames[0];
        const dst_rect = Rectangle
        {
            .x = self.position.x,
            .y = self.position.y,
            .width = src_rect.width * self.scale.x,
            .height = src_rect.height * self.scale.y
        };

        const origin = Vector2{ .x=0, .y=0 };

        raylib.DrawTexturePro(
            self.texture,
            src_rect,
            dst_rect,
            origin,
            0,
            raylib.WHITE);
    }
};
