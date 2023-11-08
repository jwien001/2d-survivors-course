extends Node2D
class_name AxeAbility


@export_range(0.001, 3600, 0.001, "exp", "suffix:s") var duration: float = 3.0
@export var max_radius: float = 100.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var player: Node2D
var base_rotation = Vector2.RIGHT
var current_radius: float = 0.0


func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Node2D
    base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

    var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).set_parallel()
    tween.tween_property(self, "current_radius", max_radius, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
    tween.tween_method(_tween_method, 0.0, 2.0, duration)
    tween.chain().tween_callback(queue_free)


func _tween_method(rotations: float):
    if !player: return

    var current_direction = base_rotation.rotated(rotations * TAU)

    global_position = player.global_position + (current_direction * current_radius)
