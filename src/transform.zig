const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

const Vector2 = raylib.Vector2;

pub const Transform = struct
{
    position:   Vector2  = .{.x=0, .y=0},
    scale:      Vector2  = .{.x=1, .y=1},
    rotation:   f32             = 0
};