const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Texture = raylib.Texture;

const print = @import("std").debug.print;

const Scene         = @import("scene.zig").Scene;
const Actor         = @import("actor.zig").Actor;
const GameObject    = @import("game_object.zig").GameObject;
const Drawable      = @import("drawable.zig").Drawable;
const Transform     = @import("transform.zig").Transform;

pub fn build_player(texture: Texture, scale: f32, scene: *Scene) Actor
{
    const window_width  = @intToFloat(f32, raylib.GetRenderWidth());
    const texture_width = @intToFloat(f32, texture.width) * scale;
    const position_x    = (window_width - texture_width) * 0.5;

    const window_height     = @intToFloat(f32, raylib.GetRenderHeight());
    const texture_height    = @intToFloat(f32, texture.height) * scale;
    const position_y        = window_height - texture_height;

    const transform = Transform{.position = .{.x = position_x, .y = position_y},
                                .scale = scale};

    const drawable = Drawable{.transform = transform, .texture = texture};

    return Actor{.game_object = GameObject.new(drawable, scene),
                 .update_impl = &player_update};
}

fn player_update(self: *Actor) void
{
    const delta_time = raylib.GetFrameTime();

    // TODO: Receive damage
    // TODO: Jump
    if (raylib.IsKeyDown(raylib.KEY_D))
    {
        self.game_object.drawable.transform.position.x += self.move_speed * delta_time;
    }
    else if (raylib.IsKeyDown(raylib.KEY_A))
    {
        self.game_object.drawable.transform.position.x -= self.move_speed * delta_time;
    }
    // TODO: Attack
}