extends Node2D

@onready var sprite = $Sprite2D

var player: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Node2D
    $Area2D.area_entered.connect(_on_area_entered, CONNECT_ONE_SHOT)


func _on_area_entered(_otherArea: Area2D):
    var tween = create_tween().set_parallel()
    tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
    tween.tween_property(sprite, "scale", Vector2.ZERO, 0.05).set_delay(0.45)
    tween.chain().tween_callback(collect)


func tween_collect(percent: float, start_pos: Vector2):
    if !player: return

    var player_center = player.global_position + Vector2(0, -5)
    global_position = start_pos.lerp(player_center, percent)

    var target_rotation = (player_center - start_pos).angle() + deg_to_rad(90)
    rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect():
    GameEvents.emit_experience_vial_collected(1)
    $AudioStreamPlayer2D.play()
    await $AudioStreamPlayer2D.finished
    queue_free()
