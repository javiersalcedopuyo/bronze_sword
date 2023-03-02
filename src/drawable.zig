const std = @import("std");
const Transform = @import("transform.zig").Transform;
const Direction = @import("transform.zig").Direction;

const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

const Texture   = raylib.Texture;
const Color     = raylib.Color;
const Vector2   = raylib.Vector2;
const Rectangle = raylib.Rectangle;

pub const Drawable = struct
{
    const Self = @This();

    texture:    Texture,
    region:     Rectangle,
    tint:       Color       = raylib.WHITE,
    transform:  Transform   = .{},

    pub fn new(texture: Texture) Self
    {
        return Self
        {
            .texture = texture,
            .region = Rectangle
            {
                .x      = 0,
                .y      = 0,
                .width  = @intToFloat(f32, texture.width),
                .height = @intToFloat(f32, texture.height)
            }
        };
    }

    pub fn draw(self: *const Self) void
    {
        var dst_rect = Rectangle
        {
            .x = self.transform.position.x,
            .y = self.transform.position.y,
            // The sign of the source rectangle is needed to mirror the texture, but the destination
            // will always be positive
            .width  = std.math.fabs(self.region.width)  * self.transform.scale.x,
            .height = std.math.fabs(self.region.height) * self.transform.scale.y
        };

        const origin = Vector2{.x=0, .y=0};

        raylib.DrawTexturePro(self.texture,
                              self.region,
                              dst_rect,
                              origin,
                              self.transform.rotation,
                              self.tint);
    }

    pub fn get_direction(self: *const Self) Direction
    {
        return self.transform.direction;
    }

    pub fn set_direction(self: *Self, dir: Direction) void
    {
        self.transform.direction = dir;
    }
};