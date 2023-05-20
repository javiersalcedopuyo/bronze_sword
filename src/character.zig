const std = @import("std");
const raylib = @cImport({
    @cInclude("raylib.h");
});

const Rectangle = raylib.Rectangle;
const Texture = raylib.Texture;
const Vector2 = raylib.Vector2;

pub const Direction = enum(i8)
{
    right = 1,
    left  = -1
};

pub const State = enum(u8)
{
    idle,
    walking,
    jumping,
    attacking,
    dead
};

pub const Character = struct
{
    const Self = @This();

    texture:    Texture,
    frames:     []const Rectangle,

    current_frame: usize = 0,

    facing_direction: Direction = .right,
    state: State = .idle,

    position:   Vector2 = .{ .x=0, .y=0 },
    scale:      Vector2 = .{ .x=1, .y=1 },

    move_speed: f32 = 100,
    timer:      f32 = 0,

    update_impl: *const fn(*Self) void = dummy_update,

    pub fn draw(self: *Self) void
    {
        std.debug.assert( self.current_frame <= self.frames.len );

        var src_rect = self.frames[ self.current_frame ];
        const dst_rect = Rectangle
        {
            .x = self.position.x,
            .y = self.position.y,
            .width = src_rect.width * self.scale.x,
            .height = src_rect.height * self.scale.y
        };

        src_rect.width *= @intToFloat(f32, @enumToInt(self.facing_direction));

        const origin = Vector2{ .x=0, .y=0 };

        raylib.DrawTexturePro(
            self.texture,
            src_rect,
            dst_rect,
            origin,
            0,
            raylib.WHITE);
    }

    pub fn update(self: *Self) void
    {
        self.update_impl( self );
    }

    // Only changes position and facing direction.
    // Animation frames and other logic should be handled in the update
    pub fn walk(self: *Character) void
    {
        const delta_time = raylib.GetFrameTime();

        self.position.x +=
            self.move_speed *
            delta_time *
            @intToFloat(f32, @enumToInt(self.facing_direction));
    }

    fn dummy_update(_: *Self) void {}
};
