const Character = @import( "character.zig" ).Character;

const raylib = @cImport({
    @cInclude("raylib.h");
});
const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;

const PLAYER_SPRITE_WIDTH   = 29;
const PLAYER_SPRITE_HEIGHT  = 55;
const PLAYER_SCALE          = 4;

pub const Game = struct
{
    const Self = @This();

    title: []const u8,
    window_size: Vector2,

    background: raylib.Texture = undefined,
    player: Character = undefined,

    pub fn init(self: *Self) void
    {
        raylib.InitWindow(@floatToInt(c_int, self.window_size.x),
                          @floatToInt(c_int, self.window_size.y),
                          self.title.ptr);
        raylib.SetTargetFPS(60);

        self.background = raylib.LoadTexture( "assets/background2.png" );

        self.player = Character
        {
            .texture  = raylib.LoadTexture( "assets/elite.png" ),
            .scale    = Vector2{ .x = PLAYER_SCALE, .y = PLAYER_SCALE },
            .position = Vector2
            {
                // Start in the middle of the screen, standing on the ground
                .x = (self.window_size.x - (PLAYER_SPRITE_WIDTH * PLAYER_SCALE)) * 0.5,
                .y = self.window_size.y - (PLAYER_SPRITE_HEIGHT * PLAYER_SCALE)
            },
            .frames = &[_]Rectangle
            {
                // Idle
                .{ .x = 0, .y = 0, .width = PLAYER_SPRITE_WIDTH, .height = PLAYER_SPRITE_HEIGHT }
            }
        };
    }

    pub fn deinit(self: *Self) void
    {
        raylib.UnloadTexture( self.background );
        raylib.CloseWindow();
    }

    pub fn run_game_loop(self: *Self) void
    {
        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.SKYBLUE);

        self.DrawBackground();
        self.player.draw();

        raylib.EndDrawing();
    }

    fn DrawBackground(self: *Self) void
    {
        const src_rect = Rectangle
        {
            .x = 0,
            .y = 0,
            .width  = @intToFloat( f32, self.background.width ),
            .height = @intToFloat( f32, self.background.height )
        };
        const dst_rect = Rectangle
        {
            .x = 0,
            .y = 0,
            .width = self.window_size.x,
            .height = self.window_size.y
        };

        const origin = Vector2{ .x=0, .y=0 };

        raylib.DrawTexturePro
        (
            self.background,
            src_rect,
            dst_rect,
            origin,
            0, // rotation
            raylib.LIGHTGRAY // tint
        );   
    }
};
