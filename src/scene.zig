const std = @import("std");
const ArrayList = std.ArrayList;
const print = std.debug.print;

const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

const Background = @import("background.zig").Background;
const Actor  = @import("actor.zig").Actor;

const allocator = std.heap.c_allocator;

const build_player = @import("player.zig").build_player;
const build_wizard = @import("wizard.zig").build_wizard;

pub fn build_scene(id: SceneID) Scene
{
    switch (id)
    {
        .game =>
        {
            const tex = raylib.LoadTexture("assets/background2.png");
            var scene = Scene{.id = id,
                              .background = Background.new(tex)};
            scene.background.drawable.tint = raylib.LIGHTGRAY;

            const player_sprite = raylib.LoadTexture("assets/elite.png");
            scene.player = build_player(player_sprite, 4, &scene);

            const wizard_sprite = raylib.LoadTexture("assets/wizard.png");
            scene.enemies.append( build_wizard(wizard_sprite, 4, &scene) ) catch |e|
            {
                print("Couldn't append player. {}", .{e});
            };
            return scene;
        },
        .title, .death, .victory =>
        {
            print("🚧 UNIMPLEMENTED: Scene ID {}\n", .{id});
            return Scene{.id = id};
        },
    }
}

pub const Scene = struct
{
    const Self = @This();

    id: SceneID,
    background: Background = undefined, // TODO: ArrayList
    player: ?Actor = null,
    enemies: ArrayList(Actor) = ArrayList(Actor).init(allocator),
    score: u8 = 0,

    pub fn update(self: *Self) void
    {
        self.background.update();

        if (self.player) |*pc|
        {
            pc.update();
        }

        for (self.enemies.items) |*enemy|
        {
            enemy.update();
            // TODO: Remove dead enemies
        }
    }

    pub fn draw(self: *Self) void
    {
        self.background.draw();
        raylib.DrawText(self.get_score_text().ptr, 8, 4, 32, raylib.WHITE);
        raylib.DrawText(get_fps_text().ptr, 8, 36, 24, raylib.GREEN);

        for (self.enemies.items) |enemy|
        {
            enemy.draw();
        }

        if (self.player) |pc|
        {
            pc.draw();
        }
    }

    fn get_score_text(self: *const Self) []const u8
    {
        return std.fmt.allocPrint(allocator, "Score: {d}", .{self.score})
                catch "Score: ???";
    }

};

fn get_fps_text() [] const u8
{
    const fps = @floor(1 / raylib.GetFrameTime());
    return std.fmt.allocPrint(allocator, "{d}fps", .{fps})
            catch "???fps";
}

pub const SceneID = enum(u8)
{
    title,
    game,
    death,
    victory,

    pub const count = @enumToInt(SceneID.victory) + 1;
};