extends CanvasLayer
class_name EndScreen

@onready var panel_container = %PanelContainer


func _ready() -> void:
    panel_container.pivot_offset = panel_container.size / 2

    var tween = create_tween()
    tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
    tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

    get_tree().paused = true
    %ContinueButton.pressed.connect(_on_continue_button_pressed)
    %QuitButton.pressed.connect(_on_quit_button_pressed)


func _exit_tree() -> void:
    get_tree().paused = false


func set_defeat():
    MetaProgression.save_data()
    %TitleLabel.text = "Defeat"
    %DescriptionLabel.text = "You lost!"
    $DefeatStreamPlayer.play()


func set_victory():
    MetaProgression.save_data()
    $VictoryStreamPlayer.play()


func _on_continue_button_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func _on_quit_button_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway
    get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
