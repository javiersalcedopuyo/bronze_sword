const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Vector2 = raylib.Vector2;

const print = @import("std").debug.print;

const Scene = @import("scene.zig").Scene;
const SceneID = @import("scene.zig").SceneID;
const build_scene = @import("scene.zig").build_scene;

pub const Game = struct
{
    const Self = @This();

    title: []const u8,
    window_size: Vector2,
    scenes: [SceneID.id_count]Scene = undefined,

    active_scene_ID: SceneID = .game,

    pub fn init(self: *Self) void
    {
        raylib.InitWindow(@floatToInt(c_int, self.window_size.x),
                          @floatToInt(c_int, self.window_size.y),
                          self.title.ptr);
        raylib.SetTargetFPS(60);

        // TODO: Initialise all scenes
        self.scenes[@enumToInt(SceneID.game)] = build_scene(.game);
    }

    pub fn clean_up(self: *Self) void
    {
        _ = self;
        raylib.CloseWindow();
    }

    pub fn run_game_loop(self: *Self) void
    {
        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.SKYBLUE);

        self.get_active_scene().update();
        self.get_active_scene().draw();

        raylib.EndDrawing();
    }

    fn get_active_scene(self: *Self) *Scene
    {
        return &self.scenes[@enumToInt(self.active_scene_ID)];
    }
};