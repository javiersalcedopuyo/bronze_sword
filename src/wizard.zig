const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});
const Texture   = raylib.Texture;
const Rectangle = raylib.Rectangle;

const print = @import("std").debug.print;
const RNG  = @import("std").rand.DefaultPrng;

const Scene         = @import("scene.zig").Scene;
const Actor         = @import("actor.zig").Actor;
const Direction     = @import("actor.zig").Direction;
const GameObject    = @import("game_object.zig").GameObject;
const Drawable      = @import("drawable.zig").Drawable;
const Transform     = @import("transform.zig").Transform;

pub fn build_wizard(texture: Texture, scale: f32, scene: *Scene) Actor
{
    // Spawn just outside of the screen
    const position_x = @intToFloat(f32, raylib.GetRenderWidth());

    const window_height     = @intToFloat(f32, raylib.GetRenderHeight());
    const texture_height    = @intToFloat(f32, texture.height) * scale;
    const position_y        = window_height - texture_height;

    // TODO: Make it random when the background movement is implemented
    const direction = Direction.left;

    const drawable = Drawable
    {
        .texture   = texture,
        .transform = Transform
        {
            .position = .{.x = position_x, .y = position_y},
            .scale    = .{.x = scale, .y = scale}
        },
        .region    = Rectangle
        {
            .x = 0,
            .y = 0,
            .width = @intToFloat(f32, texture.width * @enumToInt(direction)),
            .height = @intToFloat(f32, texture.height)
        }
    };

    return Actor{.game_object = GameObject.new(drawable, scene),
                 .update_impl = &wizard_update,
                 .move_speed  = 50,
                 .direction   = direction};
}

fn wizard_update(self: *Actor) void
{
    const static = struct
    {
        var rng = RNG.init(0xdeadbeef);
        var accumulated_seconds: f32 = 0;
    };

    const delta_time = raylib.GetFrameTime();

    static.accumulated_seconds += delta_time;
    if (static.accumulated_seconds > 2)
    {
        if (static.rng.random().boolean())
        {
            self.direction = @intToEnum(Direction, @enumToInt(self.direction) * -1);
            // Flip the texture
            self.game_object.drawable.region.width *= -1;
        }
        static.accumulated_seconds = 0;
    }

    const movement = self.move_speed * delta_time * @intToFloat(f32, @enumToInt(self.direction));
    self.game_object.drawable.transform.position.x += movement;
}