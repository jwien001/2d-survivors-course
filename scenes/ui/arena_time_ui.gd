extends CanvasLayer


@export var arena_timer_manager: ArenaTimeManager

@onready var label = %Label


func _process(_delta):
    if !arena_timer_manager: return

    var time_elapsed = arena_timer_manager.get_time_elapsed()
    label.text = format_seconds(time_elapsed)


func format_seconds(seconds: int) -> String:
    return "%d:%02d" % [(seconds / 60) % 60, seconds % 60]
