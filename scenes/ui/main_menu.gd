extends CanvasLayer
class_name MainMenu

var options_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready() -> void:
    %PlayButton.pressed.connect(_on_play_pressed)
    %UpgradesButton.pressed.connect(_on_upgrades_pressed)
    %OptionsButton.pressed.connect(_on_options_pressed)
    %QuitButton.pressed.connect(_on_quit_pressed)


func _on_play_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway

    get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_upgrades_pressed():
    ScreenTransition.transition()
    await ScreenTransition.transitioned_halfway

    get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn")


func _on_options_pressed():
    ScreenTransition.transition(1.5)
    await ScreenTransition.transitioned_halfway

    var options_scene_instance = options_scene.instantiate() as OptionsMenu
    add_child(options_scene_instance)
    options_scene_instance.back_pressed.connect(_on_options_closed.bind(options_scene_instance))


func _on_options_closed(options_instance: OptionsMenu):
    options_instance.queue_free()


func _on_quit_pressed():
    get_tree().quit()
