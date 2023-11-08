extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: Player


func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Player
    if !player: return

    await player.ready
    player.get_health_component().health_changed.connect(_on_player_health_changed)


func _on_player_health_changed(delta: float, current_health: float, max_health: float):
    if delta >= 0: return

    var damage_normalized = clamp(-delta / current_health, 0.0, 1.0)
    var opacity = lerp(0.2, 0.333, damage_normalized)
    print(opacity)

    animation_player.get_animation("hit").track_set_key_value(2, 1, opacity)
    animation_player.play("hit")
