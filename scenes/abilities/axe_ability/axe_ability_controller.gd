extends Node
class_name AxeAbilityController


@export var base_damage: float = 10
@export var axe_ability: PackedScene

var player: Node2D
var foreground_node: Node2D
var damage: float = base_damage


func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Node2D
    foreground_node = get_tree().get_first_node_in_group("foreground_node") as Node2D
    $Timer.timeout.connect(_on_timer_timeout)
    GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout():
    if !player: return

    var axe_instance: AxeAbility = axe_ability.instantiate() as AxeAbility
    axe_instance.global_position = player.global_position
    foreground_node.add_child(axe_instance)
    axe_instance.hitbox_component.damage = damage


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if upgrade.id == "axe_damage":
        damage = base_damage * pow(1.1, current_upgrades["axe_damage"]["quantity"])
