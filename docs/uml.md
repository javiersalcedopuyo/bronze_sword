```mermaid
classDiagram

class Game{
    run_game_loop()
    title: String
    window_size: Vector2
    active_scene_ID: enum
}

class Scene{
    init()
    clean_up()
    update()
    draw()
    points: u32
}

class Actor{
    init()
    update()
    health: u8
    move_speed: f32
}

class Item{
    value: u8
    type: enum
}

class Background{
    new()
    update()
    draw()
}

class Drawable{
    draw()
    get_direction(): enum
    set_direction()
    region: Rectangle
    tint: Color
}

class Transform{
    position: Vector2
    scale: f32
    rotation: f32
    direction: enum
}

class Weapon{
    is_ranged: bool
    damage: u8
    cooldown: f32
    spawn_projectile()
}

class Projectile{
    update()
    damage: u8
    move_speed: f32
}

class GameObject{
    new(): GameObject
    intersects(): bool
    get_direction(): enum
    set_direction()
    set_animation()
    draw()
    bounding_box_size: Vector2
    state: enum
}

class Container{
    open()
}

class Animation{
    current_frame: u8
    frame_rate: u8
    seconds_since_last_frame: f32
    frames: []Rectangles
    update()
    get_current_frame(): Rectangle
}

Game --* "N" Scene

Scene --* Background
Scene --* "0..N" Actor
Scene --* "0..N" Container
Scene --* "0..N" Item
Scene --* "0..N" Projectile
Scene --* "1..N" Texture

Container ..> Item: Spawns

Background --* "1..N" Drawable

GameObject --* Drawable
GameObject --o Scene
GameObject --* "0..N" Animation

Actor --* GameObject
Container --* GameObject
Item --* GameObject
Weapon --* GameObject
Projectile --* GameObject

Drawable --* Transform

Drawable --o Texture

Actor --* Weapon

Weapon ..> Projectile: Spawns
```