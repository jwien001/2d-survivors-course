extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals


func _ready() -> void:
    $HurtboxComponent.hit.connect(_on_hit)


func _process(delta: float) -> void:
    velocity_component.accelerate_to_player()
    velocity_component.move(self)

    var move_sign = sign(velocity.x)
    if move_sign != 0:
        visuals.scale.x = move_sign


func _on_hit():
    $AudioStreamPlayer2D.play()
