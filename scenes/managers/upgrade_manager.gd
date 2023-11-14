extends Node
class_name UpgradeManager


@export var num_choices: int = 2
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades: Dictionary = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_anvil = preload("res://resources/upgrades/anvil.tres")
var upgrade_anvil_amount = preload("res://resources/upgrades/anvil_amount.tres")


func _ready() -> void:
    upgrade_pool.add_item(upgrade_axe, 10)
    upgrade_pool.add_item(upgrade_sword_rate, 10)
    upgrade_pool.add_item(upgrade_sword_damage, 10)
    upgrade_pool.add_item(upgrade_player_speed, 5)
    upgrade_pool.add_item(upgrade_anvil, 10)

    experience_manager.level_up.connect(_on_level_up)


func _on_level_up(_current_level: int):
    var chosen_upgrades: Array[AbilityUpgrade] = _pick_upgrades()
    if chosen_upgrades.is_empty(): return

    var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
    add_child(upgrade_screen_instance)
    upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
    upgrade_screen_instance.upgrade_selected.connect(_on_upgrade_selected)


func _on_upgrade_selected(upgrade: AbilityUpgrade):
    _apply_upgrade(upgrade)


func _apply_upgrade(upgrade: AbilityUpgrade):
    if not current_upgrades.has(upgrade.id):
        current_upgrades[upgrade.id] = {
            "resource": upgrade,
            "quantity": 0
        }

    current_upgrades[upgrade.id]["quantity"] += 1

    _update_upgrade_pool(upgrade)

    GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func _pick_upgrades() -> Array[AbilityUpgrade]:
    var ret: Array[AbilityUpgrade]
    ret.assign(upgrade_pool.pick_items(num_choices))
    return ret


func _update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
    if chosen_upgrade.max_quantity > 0 and current_upgrades[chosen_upgrade.id]["quantity"] >= chosen_upgrade.max_quantity:
        upgrade_pool.remove_item(chosen_upgrade)

    if chosen_upgrade.id == upgrade_axe.id:
        upgrade_pool.add_item(upgrade_axe_damage, 10)
    elif chosen_upgrade.id == upgrade_anvil.id:
        upgrade_pool.add_item(upgrade_anvil_amount, 5)
