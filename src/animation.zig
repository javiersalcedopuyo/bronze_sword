const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

const Rectangle = raylib.Rectangle;

pub const Animation = struct
{
    const Self = @This();

    frame_rate: u8,
    frames: []const Rectangle,
    current_frame: u8 = 0,
    seconds_since_last_frame: f32 = 0, // Maybe usize?

    pub fn update(self: *Self) void
    {
        if (self.frame_rate == 0)
        {
            return;
        }

        if (self.seconds_since_last_frame >= 1 / @intToFloat(f32, self.frame_rate))
        {
            self.seconds_since_last_frame = 0;
            self.advance_frame();
        }
        else
        {
            self.seconds_since_last_frame += raylib.GetFrameTime();
        }
    }

    pub fn get_current_frame(self: *const Self) Rectangle
    {
        return self.frames[self.current_frame];
    }

    fn advance_frame(self: *Self) void
    {
        self.current_frame = (self.current_frame + 1) % @truncate(u8, self.frames.len);
    }
};