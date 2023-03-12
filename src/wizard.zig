const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Texture   = raylib.Texture;
const Rectangle = raylib.Rectangle;

const print = @import("std").debug.print;
const RNG  = @import("std").rand.DefaultPrng;

const Scene         = @import("scene.zig").Scene;
const Actor         = @import("actor.zig").Actor;
const GameObject    = @import("game_object.zig").GameObject;
const Drawable      = @import("drawable.zig").Drawable;
const Transform     = @import("transform.zig").Transform;
const Direction     = @import("transform.zig").Direction;
const Animation     = @import("animation.zig").Animation;

const FRAME_WIDTH  = 29;
const FRAME_HEIGHT = 55;

pub fn build_wizard(texture: Texture, scale: f32, scene: *Scene) Actor
{
    // Spawn just outside of the screen
    const position_x = @intToFloat(f32, raylib.GetRenderWidth());

    const texture_width     = @intToFloat(f32, FRAME_WIDTH) * scale;
    const texture_height    = @intToFloat(f32, FRAME_HEIGHT) * scale;
    const window_height     = @intToFloat(f32, raylib.GetRenderHeight());
    const position_y        = window_height - texture_height;

    // TODO: Make it random when the background movement is implemented
    const direction = Direction.left;

    const drawable = Drawable
    {
        .texture   = texture,
        .transform = Transform
        {
            .position   = .{.x = position_x, .y = position_y},
            .scale      = .{.x = scale, .y = scale},
            .direction  = direction
        },
        .region    = Rectangle
        {
            .x = 0,
            .y = 0,
            .width = texture_width * @intToFloat(f32, @enumToInt(direction)),
            .height = texture_height
        }
    };

    var go = GameObject.new(drawable, State.count, scene);
    go.animations.items[@enumToInt(State.walk)] = Animation
    {
        .frame_rate = 2,
        .frames = &[_]Rectangle
        {
            .{.x=0, .y=0, .width=FRAME_WIDTH, .height=FRAME_HEIGHT},
            .{.x=FRAME_WIDTH, .y=0, .width=FRAME_WIDTH, .height=FRAME_HEIGHT},
        }
    };

    return Actor{.game_object = go,
                 .update_impl = &wizard_update,
                 .move_speed  = 50};
}

fn wizard_update(self: *Actor) void
{
    const static = struct
    {
        var rng = RNG.init(0xdeadbeef);
        var accumulated_seconds: f32 = 0; // FIXME: This won't work with multiple wizards
    };

    // TODO: Attack the player
    self.game_object.state = @enumToInt(State.walk);

    const delta_time = raylib.GetFrameTime();

    static.accumulated_seconds += delta_time;
    if (static.accumulated_seconds > 2)
    {
        if (static.rng.random().boolean())
        {
            const new_dir = @intToEnum(Direction, @enumToInt(self.game_object.get_direction()) * -1);
            self.game_object.set_direction(new_dir);
        }
        static.accumulated_seconds = 0;
    }

    const movement = self.move_speed *
                     delta_time *
                     @intToFloat(f32, @enumToInt(self.game_object.get_direction()));

    self.game_object.drawable.transform.position.x += movement;

    self.game_object.set_animation( self.game_object.state ) catch |e|
    {
        switch (e)
        {
            error.OutOfBounds =>
            {
                print("❌ ERROR @ wizard_update: Out Of Bounds access at {}\n",
                      .{self.game_object.state});
            },
            error.AnimationUnset =>
            {
                print("⚠️ WARNING @ wizard_update: The state {} doesn't have an animation assigned.\n",
                      .{self.game_object.state});
            }
        }
    };
}

const State = enum(u8)
{
    walk,
    attack,

    const count: usize = @enumToInt(State.attack) + 1;
};