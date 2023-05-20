const Character = @import( "character.zig" ).Character;
const Player = @import( "player.zig" );
const Wizard = @import( "wizard.zig" );

const raylib = @cImport({
    @cInclude("raylib.h");
});
const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;

const MAX_ENEMIES = 8;

pub const Game = struct
{
    const Self = @This();

    title: []const u8,
    window_size: Vector2,

    background: raylib.Texture = undefined,
    player: Character = undefined,
    enemies: [MAX_ENEMIES]?Character = .{null} ** MAX_ENEMIES,

    pub fn init(self: *Self) void
    {
        raylib.InitWindow(@floatToInt(c_int, self.window_size.x),
                          @floatToInt(c_int, self.window_size.y),
                          self.title.ptr);
        raylib.SetTargetFPS(60);

        self.background = raylib.LoadTexture( "assets/background2.png" );

        self.player = Player.new();
        // Spawn the player in the middle of the screen
        self.player.position = Vector2
        {
            .x = (self.window_size.x - (Player.SPRITE_WIDTH * Player.SCALE)) * 0.5,
            .y = self.window_size.y - (Player.SPRITE_HEIGHT * Player.SCALE)
        };

        // Spawn 2 wizards at both sides of the screen, facing the player
        self.enemies[0] = Wizard.new();
        self.enemies[0].?.position = Vector2
        {
            .x = self.window_size.x - (Wizard.SPRITE_WIDTH * Wizard.SCALE),
            .y = self.window_size.y - (Player.SPRITE_HEIGHT * Player.SCALE)
        };
        self.enemies[0].?.facing_direction = .left;

        self.enemies[1] = Wizard.new();
        self.enemies[1].?.position = Vector2
        {
            .x = 0,
            .y = self.window_size.y - (Player.SPRITE_HEIGHT * Player.SCALE)
        };
    }

    pub fn deinit(self: *Self) void
    {
        raylib.UnloadTexture( self.background );
        raylib.CloseWindow();
    }

    pub fn run_game_loop(self: *Self) void
    {
        self.player.update();
        for (&self.enemies) |*opt_enemy|
        {
            if (opt_enemy.*) |*enemy|
            {
                enemy.update();
            }
        }

        self.draw();
    }

    fn draw(self: *Self) void
    {
        raylib.BeginDrawing();
        raylib.ClearBackground(raylib.SKYBLUE);

        self.DrawBackground();

        self.player.draw();

        for (&self.enemies) |*opt_enemy|
        {
            if (opt_enemy.*) |*enemy|
            {
                enemy.draw();
            }
        }

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
