extends CanvasLayer


@export var experience_manager: ExperienceManager

@onready var progress_bar = %ProgressBar


func _ready() -> void:
    progress_bar.value = 0
    experience_manager.experience_updated.connect(_on_experience_updated)


func _on_experience_updated(current_exp, target_exp) -> void:
    var percent = float(current_exp) / target_exp
    progress_bar.value = percent
