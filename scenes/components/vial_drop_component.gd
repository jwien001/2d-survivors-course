extends Node


@export_range(0, 1) var drop_rate: float = 0.5
@export var health_component: HealthComponent
@export var vial_scene: PackedScene


func _ready():
    health_component.died.connect(_on_died)


func _on_died():
    if !vial_scene: return
    if not owner is Node2D: return

    var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
    var adjusted_drop_rate = drop_rate * pow(1.1, experience_gain_upgrade_count)

    if adjusted_drop_rate <= 0 or randf() > adjusted_drop_rate: return

    var vial_instance = vial_scene.instantiate() as Node2D
    vial_instance.global_position = (owner as Node2D).global_position
    owner.get_parent().add_child(vial_instance)
