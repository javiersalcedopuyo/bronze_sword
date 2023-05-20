const raylib = @cImport({
    @cInclude("raylib.h");
});
const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;

const Character = @import( "character.zig" ).Character;

pub const SPRITE_WIDTH   = 29;
pub const SPRITE_HEIGHT  = 55;
pub const SCALE          = 4;

const SPRITE_ATLAS_PATH = "assets/elite.png";

pub fn new() Character
{
    return Character
    {
        .texture  = raylib.LoadTexture(SPRITE_ATLAS_PATH),
        .scale    = Vector2{ .x = SCALE, .y = SCALE },
        .frames = &[_]Rectangle
        {
            // Idle
            .{ .x = 0, .y = 0, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT }
        },
        .update_impl = player_update
    };
}

fn player_update(self: *Character) void
{
    const delta_time = raylib.GetFrameTime();

    if (raylib.IsKeyDown(raylib.KEY_D))
    {
        self.position.x += self.move_speed * delta_time;
    }
    else if (raylib.IsKeyDown(raylib.KEY_A))
    {
        self.position.x -= self.move_speed * delta_time;
    }
}
