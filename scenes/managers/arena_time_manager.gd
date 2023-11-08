extends Node
class_name ArenaTimeManager


signal arena_difficulty_increased(arena_difficulty: int)


@export_range(0.01, 3600, 0.01, "exp", "suffix:s") var difficulty_interval: float = 5
@export var end_screen_scene: PackedScene

@onready var timer = $Timer

var arena_difficulty: int = 0


func _ready() -> void:
    timer.timeout.connect(_on_timer_timeout)


func _process(delta: float) -> void:
    var next_time_target = timer.wait_time - (arena_difficulty + 1) * difficulty_interval
    if (timer.time_left <= next_time_target):
        arena_difficulty += 1
        arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
    return timer.wait_time - timer.time_left


func _on_timer_timeout():
    var end_screen_instance = end_screen_scene.instantiate()
    add_child(end_screen_instance)
    end_screen_instance.set_victory()
