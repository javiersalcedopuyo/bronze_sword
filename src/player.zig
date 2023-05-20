const raylib = @cImport({
    @cInclude("raylib.h");});

const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;

const Character = @import( "character.zig" ).Character;
const Direction = @import( "character.zig" ).Direction;

pub const SPRITE_WIDTH   = 29;
pub const SPRITE_HEIGHT  = 55;
pub const SCALE          = 4;

const SPRITE_ATLAS_PATH = "assets/elite.png";

pub fn new() Character
{
    return Character
    {
        .texture = raylib.LoadTexture(SPRITE_ATLAS_PATH),
        .scale   = Vector2{ .x = SCALE, .y = SCALE },
        .frames  = &[_]Rectangle
        {
            // Idle
            .{ .x = 0, .y = 0, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT },
            // Walk loop 1
            .{ .x = SPRITE_WIDTH, .y = 0, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT },
            // Walk loop 2
            .{ .x = SPRITE_WIDTH * 2, .y = 0, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT },
            // Attack
            .{ .x = 0, .y = SPRITE_HEIGHT, .width = SPRITE_WIDTH, .height = SPRITE_HEIGHT },
        },
        .update_impl = player_update
    };
}

fn player_update(self: *Character) void
{
    process_input(self);

    switch (self.state)
    {
        .walking =>
        {
            const time_since_start = raylib.GetTime();
            // Take a step every 0.5s
            const is_first_step = time_since_start - @trunc(time_since_start) >= 0.5;
            self.current_frame = if (is_first_step) 1 else 2;
            self.walk();
        },
        .idle       => self.current_frame = 0,
        .attacking  => self.current_frame = 3,
        else => {}
    }
}

fn process_input(self: *Character) void
{
    if (self.state == .dead)
        return;

    self.state = .idle;

    if (raylib.IsKeyDown(raylib.KEY_D))
    {
        self.state = .walking;
        self.facing_direction = Direction.right;
    }
    else if (raylib.IsKeyDown(raylib.KEY_A))
    {
        self.state = .walking;
        self.facing_direction = Direction.left;
    }

    // Attacking overrides the walking state
    if (raylib.IsKeyDown(raylib.KEY_J))
    {
        // TODO: Add an attack duration and cooldown
        self.state = .attacking;
    }
}
