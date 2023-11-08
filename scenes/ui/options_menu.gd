extends CanvasLayer
class_name OptionsMenu

signal back_pressed

@onready var window_mode_button: Button = %WindowModeButton
@onready var master_slider: HSlider = %MasterSlider
@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider


func _ready() -> void:
    window_mode_button.pressed.connect(_on_window_mode_pressed)
    master_slider.value_changed.connect(_on_audio_slider_changed.bind("Master"))
    sfx_slider.value_changed.connect(_on_audio_slider_changed.bind("Sound Effects"))
    music_slider.value_changed.connect(_on_audio_slider_changed.bind("Music"))
    %BackButton.pressed.connect(_on_back_pressed)
    update_display()


func _on_window_mode_pressed():
    var mode = DisplayServer.window_get_mode()
    if mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
        DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

    update_display()


func _on_audio_slider_changed(value: float, bus_name: String):
    set_bus_volume_percent(bus_name, value)
    update_display()


func _on_back_pressed():
    ScreenTransition.transition(1.5)
    await ScreenTransition.transitioned_halfway

    back_pressed.emit()


func get_bus_volume_percent(bus_name: String):
    var bus_idx = AudioServer.get_bus_index(bus_name)
    var volume_db = AudioServer.get_bus_volume_db(bus_idx)
    return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
    var bus_idx = AudioServer.get_bus_index(bus_name)
    var volume_db = linear_to_db(percent)
    AudioServer.set_bus_volume_db(bus_idx, volume_db)


func update_display():
    if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
        window_mode_button.text = "Fullscreen"
    else:
        window_mode_button.text = "Windowed"

    master_slider.value = get_bus_volume_percent("Master")
    sfx_slider.value = get_bus_volume_percent("Sound Effects")
    music_slider.value = get_bus_volume_percent("Music")
