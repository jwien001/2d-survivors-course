extends CanvasLayer
class_name PauseMenu

@onready var panel_container: PanelContainer = %PanelContainer

var options_menu_scene: PackedScene = preload("res://scenes/ui/options_menu.tscn")

var is_closing = false


func _ready() -> void:
    get_tree().paused = true

    %ResumeButton.pressed.connect(_on_resume_pressed)
    %OptionsButton.pressed.connect(_on_options_pressed)
    %QuitButton.pressed.connect(_on_quit_pressed)
    $AnimationPlayer.play("default")

    panel_container.pivot_offset = panel_container.size / 2
    var tween = create_tween()
    tween.tween_property(panel_container, "scale", Vector2.ONE, .3).from(Vector2.ZERO).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        close()
        get_tree().root.set_input_as_handled()


func _on_resume_pressed():
    close()


func _on_options_pressed():
    ScreenTransition.transition(1.5)
    await ScreenTransition.transitioned_halfway

    var options_menu_instance = options_menu_scene.instantiate() as OptionsMenu
    add_child(options_menu_instance)
    options_menu_instance.back_pressed.connect(_on_options_back_pressed.bind(options_menu_instance))


func _on_options_back_pressed(options_menu: OptionsMenu):
    options_menu.queue_free()


func _on_quit_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway

    get_tree().paused = false
    get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func close():
    if is_closing: return

    is_closing = true

    $AnimationPlayer.play_backwards("default")

    var tween = create_tween()
    tween.tween_property(panel_container, "scale", Vector2.ZERO, .3).from(Vector2.ONE).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)

    await tween.finished

    get_tree().paused = false
    queue_free()
