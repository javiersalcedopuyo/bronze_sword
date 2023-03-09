const std = @import("std");
const Drawable = @import("drawable.zig").Drawable;
const Transform = @import("transform.zig").Transform;

const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Texture = raylib.Texture;

const GameObject = @import("game_object.zig").GameObject;

pub const Actor = struct
{
    const Self = @This();

    game_object:    GameObject,
    health:         u8  = 100,
    move_speed:     f32 = 100,
    update_impl:    *const fn (*Self) void = &Self.dummy_update,

    pub fn deinit(self: *Self) void
    {
        self.game_object.deinit();
    }

    pub fn draw(self: *const Self) void
    {
        self.game_object.draw();
    }

    pub fn update(self: *Self) void
    {
        self.update_impl(self);
    }

    fn dummy_update(self: *Self) void { _ = self; }
};