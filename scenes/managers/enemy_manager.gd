extends Node


@export var spawn_rate_difficulty_increment: float = 0.014
@export_flags_2d_physics var terrain_layer_mask
@export var arena_time_manager: ArenaTimeManager
@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene

@onready var timer = $Timer

var player: Node2D
var entities_node: Node2D
var enemy_table = WeightedTable.new()
var num_to_spawn = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Node2D
    entities_node = get_tree().get_first_node_in_group("entities_node") as Node2D
    timer.timeout.connect(_on_timer_timeout)
    arena_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

    enemy_table.add_item(basic_enemy_scene, 10)


func get_spawn_position() -> Vector2:
    if !player: return Vector2.ZERO

    var random_dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
    for i in 4:
        var spawn_pos = player.global_position + random_dir * get_viewport().get_visible_rect().size.y
        var additional_offset = random_dir * 20

        var ray_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_pos + additional_offset, terrain_layer_mask)
        var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_params)
        if result.is_empty():
            return spawn_pos

        random_dir = random_dir.rotated(deg_to_rad(90))

    return player.global_position


func spawn_enemy():
    var enemy_scene = enemy_table.pick_item()
    var enemy_instance = enemy_scene.instantiate() as Node2D
    enemy_instance.global_position = get_spawn_position()
    entities_node.add_child(enemy_instance)


func _on_timer_timeout():
    timer.start()

    if !player: return

    for i in num_to_spawn:
        spawn_enemy()


func _on_arena_difficulty_increased(arena_difficulty: int):
    var time_off = spawn_rate_difficulty_increment
    timer.wait_time = max(timer.wait_time - time_off, 0.2)

    if arena_difficulty == 6:
        enemy_table.add_item(wizard_enemy_scene, 15)
    elif arena_difficulty == 12:
        enemy_table.add_item(bat_enemy_scene, 8)

    if (arena_difficulty % 6) == 0:
        num_to_spawn += 1
