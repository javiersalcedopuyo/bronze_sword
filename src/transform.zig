const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

pub const Transform = struct
{
    position:   raylib.Vector2  = .{.x=0, .y=0},
    scale:      f32             = 1,
    rotation:   f32             = 0
};