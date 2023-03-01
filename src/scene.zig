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

            const wizard_sprite = raylib.LoadTexture("assets/wizard_l2.png");
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
        for (self.enemies.items) |enemy|
        {
            enemy.draw();
        }

        if (self.player) |pc|
        {
            pc.draw();
        }
    }
};

pub const SceneID = enum(u8)
{
    title,
    game,
    death,
    victory,

    pub const count = @enumToInt(SceneID.victory) + 1;
};