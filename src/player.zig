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
    const window_height     = @intToFloat(f32, raylib.GetRenderHeight());
    const texture_height    = @intToFloat(f32, texture.height) * scale;
    const position_y        = window_height - texture_height;

    var drawable = Drawable.new(texture);
    drawable.transform = Transform
    {
        // Spawn at the left side of the screen
        .position = .{.x = 0, .y = position_y},
        .scale    = .{.x = scale, .y = scale}
    };

    return Actor{.game_object = GameObject.new(drawable, scene),
                 .update_impl = &player_update,
                 .move_speed  = 100};
}

fn player_update(self: *Actor) void
{
    const delta_time = raylib.GetFrameTime();

    // TODO: Receive damage
    // TODO: Jump
    if (raylib.IsKeyDown(raylib.KEY_D))
    {
        self.game_object.drawable.transform.position.x += self.move_speed * delta_time;
        self.direction = .right;
    }
    else if (raylib.IsKeyDown(raylib.KEY_A))
    {
        self.game_object.drawable.transform.position.x -= self.move_speed * delta_time;
        self.direction = .left;
    }
    // TODO: Attack
}