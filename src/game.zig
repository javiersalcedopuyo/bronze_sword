const raylib = @cImport({
    @cInclude("raylib.h");
});
const Vector2 = raylib.Vector2;

pub const Game = struct
{
    const Self = @This();

    title: []const u8,
    window_size: Vector2,

    pub fn init(self: *Self) void
    {
        raylib.InitWindow(@floatToInt(c_int, self.window_size.x),
                          @floatToInt(c_int, self.window_size.y),
                          self.title.ptr);
        raylib.SetTargetFPS(60);
    }

    pub fn deinit(_: *Self) void
    {
        raylib.CloseWindow();
    }

    pub fn run_game_loop(_: *Self) void
    {
        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.SKYBLUE);
        raylib.DrawText("Fresh Restart!", 0, 0, 32, raylib.BLACK);
        raylib.EndDrawing();
    }
};
