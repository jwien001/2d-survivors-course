extends Node
class_name ExperienceManager


signal experience_updated(current_experience: int, target_experience: int)
signal level_up(new_level: int)

@export var target_experience_growth: int = 5

var current_experience: int = 0
var target_experience: int = 1
var current_level: int  = 1


func _ready():
    GameEvents.experience_vial_collected.connect(_on_experience_vial_collected)


func _on_experience_vial_collected(number: int):
    increment_experience(number)


func increment_experience(number: int):
    current_experience += number
    experience_updated.emit(current_experience, target_experience)

    if current_experience >= target_experience:
        current_level += 1
        target_experience += target_experience_growth
        current_experience = 0
        experience_updated.emit(current_experience, target_experience)
        level_up.emit(current_level)
