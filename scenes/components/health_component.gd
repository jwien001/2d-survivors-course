extends Node
class_name HealthComponent

signal died
signal health_changed(delta: float, current_health: float, max_health: float)


@export var max_health: float = 10

@onready var current_health = max_health


func damage(damage_amt: float):
    current_health = max(current_health - damage_amt, 0)
    health_changed.emit(-damage_amt, current_health, max_health)
    Callable(check_death).call_deferred()


func check_death():
    if current_health == 0:
        died.emit()
        owner.queue_free()


func get_health_percent():
    if max_health <= 0: return 0
    return min(current_health / max_health, 1)
