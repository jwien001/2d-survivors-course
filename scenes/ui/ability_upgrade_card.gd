extends PanelContainer
class_name AbilityUpgradeCard


signal selected


@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel

var disabled = false


func _ready() -> void:
    gui_input.connect(_on_gui_input)
    mouse_entered.connect(_on_mouse_entered)


func _on_gui_input(event: InputEvent):
    if disabled: return

    if event.is_action_pressed("left_click"):
        select_card()


func _on_mouse_entered():
    if disabled: return

    $HoverAnimationPlayer.play("hover")


func select_card():
    disabled = true
    $AnimationPlayer.play("selected")

    for other_card in get_tree().get_nodes_in_group("upgrade_card"):
        if other_card != self:
            other_card.play_not_selected()

    await $AnimationPlayer.animation_finished

    selected.emit()


func play_in(delay: float = 0):
    modulate = Color.TRANSPARENT
    await get_tree().create_timer(delay).timeout
    $AnimationPlayer.play("in")


func play_not_selected():
    $AnimationPlayer.play("not_selected")


func set_ability_upgrade(upgrade: AbilityUpgrade):
    name_label.text = upgrade.name
    description_label.text = upgrade.description
