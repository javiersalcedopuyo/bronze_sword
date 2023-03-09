const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Texture = raylib.Texture;
const Rectangle = raylib.Rectangle;

const print = @import("std").debug.print;

const Scene         = @import("scene.zig").Scene;
const Actor         = @import("actor.zig").Actor;
const GameObject    = @import("game_object.zig").GameObject;
const Drawable      = @import("drawable.zig").Drawable;
const Transform     = @import("transform.zig").Transform;
const Animation     = @import("animation.zig").Animation;

const FRAME_WIDTH  = 29;
const FRAME_HEIGHT = 55;

pub fn build_player(texture: Texture, scale: f32, scene: *Scene) Actor
{
    const window_height     = @intToFloat(f32, raylib.GetRenderHeight());
    const position_y        = window_height - FRAME_HEIGHT * scale;

    var drawable = Drawable.new(texture);
    drawable.transform = Transform
    {
        // Spawn at the left side of the screen
        .position = .{.x = 0, .y = position_y},
        .scale    = .{.x = scale, .y = scale}
    };

    var go = GameObject.new(drawable, State.count, scene);
    go.animations.items[@enumToInt(State.idle)] = Animation
    {
        .frame_rate = 0, // Single frame, no animation
        .frames = &[_]Rectangle
        {
            .{.x=0, .y=0, .width=FRAME_WIDTH, .height=FRAME_HEIGHT}
        }
    };
    go.animations.items[@enumToInt(State.walk)] = Animation
    {
        .frame_rate = 2,
        .frames = &[_]Rectangle
        {
            .{.x=FRAME_WIDTH, .y=0, .width=FRAME_WIDTH, .height=FRAME_HEIGHT},
            .{.x=FRAME_WIDTH * 2, .y=0, .width=FRAME_WIDTH, .height=FRAME_HEIGHT},
        }
    };

    return Actor{.game_object = go,
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
        self.game_object.set_direction(.right);
        self.game_object.state = @enumToInt(State.walk);
    }
    else if (raylib.IsKeyDown(raylib.KEY_A))
    {
        self.game_object.drawable.transform.position.x -= self.move_speed * delta_time;
        self.game_object.set_direction(.left);
        self.game_object.state = @enumToInt(State.walk);
    }
    else
    {
        self.game_object.state = @enumToInt(State.idle);
    }
    // TODO: Attack

    self.game_object.set_animation( self.game_object.state );
}

const State = enum(u8)
{
    idle = 0,
    walk,
    jump,
    attack,

    const count: usize = @enumToInt(State.attack) + 1;
};