const Character = @import( "character.zig" ).Character;
const Player = @import( "player.zig" );
const Wizard = @import( "wizard.zig" );

const raylib = @cImport({
    @cInclude("raylib.h");
});
const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;

pub const Game = struct
{
    const Self = @This();

    title: []const u8,
    window_size: Vector2,

    background: raylib.Texture = undefined,
    player: Character = undefined,
    enemy: Character = undefined,

    pub fn init(self: *Self) void
    {
        raylib.InitWindow(@floatToInt(c_int, self.window_size.x),
                          @floatToInt(c_int, self.window_size.y),
                          self.title.ptr);
        raylib.SetTargetFPS(60);

        self.background = raylib.LoadTexture( "assets/background2.png" );

        self.player = Player.new();
        // Spawn the player in the left corner
        self.player.position = Vector2
        {
            .x = 0,
            .y = self.window_size.y - (Player.SPRITE_HEIGHT * Player.SCALE)
        };

        // Spawn a single wizard in the right corner, looking at the player
        self.enemy = Wizard.new();
        self.enemy.position = Vector2
        {
            .x = self.window_size.x - (Wizard.SPRITE_WIDTH * Wizard.SCALE),
            .y = self.window_size.y - (Player.SPRITE_HEIGHT * Player.SCALE)
        };
        self.enemy.facing_direction = .left;
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

        self.player.update();
        self.enemy.update();

        self.DrawBackground();
        self.player.draw();
        self.enemy.draw();

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
