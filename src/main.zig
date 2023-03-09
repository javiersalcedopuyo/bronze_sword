const std = @import("std");
const Game = @import("game.zig").Game;

const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Vector2 = raylib.Vector2;

pub fn main() !void
{
    var game = Game{.title = "Bronze Sword",
                    .window_size = .{.x=800, .y=600}};
    game.init();
    defer game.deinit();

    while (raylib.WindowShouldClose() == false)
    {
        game.run_game_loop();
    }
}
