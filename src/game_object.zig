const raylib = @cImport({
    @cInclude("../dependencies/raylib.h");
});

const std       = @import("std");
const print     = std.debug.print;
const allocator = std.heap.c_allocator;

const ArrayList = std.ArrayList;
const Vector2   = raylib.Vector2;
const Drawable  = @import("drawable.zig").Drawable;
const Scene     = @import("scene.zig").Scene;
const Animation = @import("animation.zig").Animation;
const Direction = @import("transform.zig").Direction;

const U8Enum = u8;

pub const GameObject = struct
{
    const Self = @This();

    drawable:           Drawable,
    scene:              *Scene,
    bounding_box_size:  Vector2 = .{.x=0, .y=0},
    animations:         ArrayList(?Animation) = ArrayList(?Animation).init(allocator), // TODO: Use a slice instead
    state:              U8Enum = 0,

    pub fn new(d: Drawable, num_animations: usize, s: *Scene) Self
    {
        var result = Self{.drawable = d, .scene = s};

        result.bounding_box_size = Vector2
        {
            .x = @intToFloat(f32, d.texture.width),
            .y = @intToFloat(f32, d.texture.height)
        };

        result.animations.appendNTimes(null, num_animations)
        catch |e|
        {
            print("❌ FATAL ERROR: {}", .{e});
            std.os.exit(1);
        };

        return result;
    }

    pub fn deinit(self: *Self) void
    {
        self.animations.deinit();
        self.drawable.deinit();
    }

    pub fn draw(self: *const Self) void
    {
        self.drawable.draw();
    }

    pub fn set_animation(self: *Self, idx: usize) !void
    {
        if (idx >= self.animations.items.len)
        {
            return error.OutOfBounds;
        }

        if (self.animations.items[idx]) |*anim|
        {
            var rect = anim.get_current_frame();
            // Flip the texture according to the facing direction
            rect.width *= @intToFloat(f32, @enumToInt(self.get_direction()));

            self.drawable.region = rect;
            anim.update();
        }
        else
        {
            return error.AnimationUnset;
        }
    }

    pub fn get_direction(self: *const Self) Direction
    {
        return self.drawable.get_direction();
    }

    pub fn set_direction(self: *Self, dir: Direction) void
    {
        self.drawable.set_direction(dir);
    }

    pub fn intersects(self: *const Self, other: Self) bool
    {
        print("🚧 UNIMPLEMENTED: GameObject.intersects", .{});
        _ = self;
        _ = other;
        return false;
    }
};

const AnimationError = error
{
    OutOfBounds,
    AnimationUnset,
};