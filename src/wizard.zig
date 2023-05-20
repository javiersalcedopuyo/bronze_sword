const raylib = @cImport({
    @cInclude("raylib.h");});

const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;

const Character = @import( "character.zig" ).Character;
const Direction = @import( "character.zig" ).Direction;
const std       = @import( "std" );
const RNG       = std.rand.DefaultPrng;


pub const SPRITE_WIDTH   = 29;
pub const SPRITE_HEIGHT  = 55;
pub const SCALE          = 4;

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
    };
}

fn update(_: *Character) void
{
}
