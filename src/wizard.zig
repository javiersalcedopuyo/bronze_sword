const raylib = @cImport({
    @cInclude("raylib.h");});

const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;

const Character = @import( "character.zig" ).Character;
const Direction = @import( "character.zig" ).Direction;
const State     = @import( "character.zig" ).State;
const std       = @import( "std" );
const RNG       = std.rand.DefaultPrng;


pub const SPRITE_WIDTH   = 29;
pub const SPRITE_HEIGHT  = 55;
pub const SCALE          = 4;
pub const MOVE_SPEED     = 50;

const SPRITE_ATLAS_PATH = "assets/wizard.png";

var rng = RNG.init(0xdeadbeef);

pub fn new() Character
{
    return Character
    {
        .texture = raylib.LoadTexture(SPRITE_ATLAS_PATH),
        .scale   = Vector2{ .x = SCALE, .y = SCALE },
        .frames  = &[_]Rectangle
        {
            // Walk loop 1
            .{ .x = 0, .y = 0, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT },
            // Walk loop 2
            .{ .x = SPRITE_WIDTH, .y = 0, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT },
            // Attack
            .{ .x = SPRITE_WIDTH * 2, .y = 0, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT },
        },
        .update_impl = update,
        .state = .walking,
        .move_speed = MOVE_SPEED
    };
}

fn update(self: *Character) void
{
    self.timer -= raylib.GetFrameTime();
    if (self.timer <= 0)
    {
        if (rng.random().boolean())
        {
            self.facing_direction = @intToEnum(Direction, @enumToInt(self.facing_direction) * -1 );
        }
        // Reset the timer to 2 seconds
        self.timer = 2;
    }

    // Do a walk animation loop per second
    const time_since_start = raylib.GetTime();
    self.current_frame = if (time_since_start - @trunc(time_since_start) >= 0.5) 0 else 1;

    self.walk();
}
