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

pub fn build_scene(id: SceneID) Scene
{
    switch (id)
    {
        .game =>
        {
            const tex = raylib.LoadTexture("assets/background2.png");
            var scene = Scene{.id = id,
                              .background = Background.new(tex)};

            const sprite = raylib.LoadTexture("assets/elite.png");
            scene.actors.append( build_player(sprite, 4, &scene) ) catch |e|
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
    actors: ArrayList(Actor) = ArrayList(Actor).init(allocator),

    pub fn update(self: *Self) void
    {
        self.background.update();
        for (self.actors.items) |*actor|
        {
            actor.update();
            // TODO: Remove dead actors
        }
    }

    pub fn draw(self: *Self) void
    {
        self.background.draw();
        for (self.actors.items) |actor|
        {
            actor.draw();
        }
    }
};

pub const SceneID = enum(u8)
{
    title,
    game,
    death,
    victory,

    pub const id_count = @enumToInt(SceneID.victory) + 1;
};