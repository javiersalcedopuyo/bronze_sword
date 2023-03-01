const Transform = @import("transform.zig").Transform;

const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

const Texture   = raylib.Texture;
const Color     = raylib.Color;

pub const Drawable = struct
{
    texture:    Texture,
    tint:       Color       = raylib.WHITE,
    transform:  Transform   = .{},

    pub fn draw(self: *const Drawable) void
    {
        raylib.DrawTextureEx(self.texture,
                             self.transform.position,
                             self.transform.rotation,
                             self.transform.scale,
                             self.tint);
    }
};