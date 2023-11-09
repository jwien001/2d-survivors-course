extends Node
class_name AnvilAbilityController

@export var base_damage: float = 15
@export var base_range: float = 100
@export var anvil_ability_scene: PackedScene

var player: Player
var foreground_node: Node2D


func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Node2D
    foreground_node = get_tree().get_first_node_in_group("foreground_node") as Node2D
    $Timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
    if !player: return

    var direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
    var spawn_pos = player.global_position + (direction * randf_range(0, base_range))

    var ray_params = PhysicsRayQueryParameters2D.create(player.global_position, spawn_pos, 1)
    var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(ray_params)
    if !result.is_empty():
        spawn_pos = result["position"]

    var anvil_ability_instance = anvil_ability_scene.instantiate() as AnvilAbility
    anvil_ability_instance.global_position = spawn_pos
    foreground_node.add_child(anvil_ability_instance)
    anvil_ability_instance.hitbox_component.damage = base_damage
