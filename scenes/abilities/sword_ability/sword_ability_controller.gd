extends Node


@export var max_range: float = 150
@export var base_damage: float = 5
@export_range(0.001, 3600, 0.001, "exp", "suffix:s") var base_cooldown: float
@export var sword_ability: PackedScene

var player: Node2D
var foreground_node: Node2D
var damage: float = base_damage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player = get_tree().get_first_node_in_group("player") as Node2D
    foreground_node = get_tree().get_first_node_in_group("foreground_node") as Node2D
    $Timer.start(base_cooldown)
    $Timer.timeout.connect(_on_timer_timeout)
    GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _on_timer_timeout():
    if !player: return

    var enemies = get_tree().get_nodes_in_group("enemy")
    if enemies.size() == 0: return

    var closest_enemy = enemies.reduce(func(closest, enemy):
        var enemy_dist = enemy.global_position.distance_squared_to(player.global_position)
        return closest if closest[1] <= enemy_dist else [enemy, enemy_dist],
        [enemies[0], enemies[0].global_position.distance_squared_to(player.global_position)]
    )[0]
    if closest_enemy.global_position.distance_squared_to(player.global_position) > pow(max_range, 2): return

    var sword_instance: SwordAbility = sword_ability.instantiate() as SwordAbility
    sword_instance.global_position = closest_enemy.global_position

    var enemy_direction: Vector2 = closest_enemy.global_position - player.global_position
    if enemy_direction.x > 0: sword_instance.scale.x = -1
    sword_instance.global_position -= Vector2.RIGHT.rotated(enemy_direction.angle()) * 32
    if enemy_direction.x > 0:
        sword_instance.rotation = enemy_direction.angle()
    else:
        sword_instance.rotation = (-enemy_direction).angle()

    foreground_node.add_child(sword_instance)
    sword_instance.hitbox_component.damage = damage


func _on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if upgrade.id == "sword_rate":
        $Timer.wait_time = base_cooldown * pow(0.7, current_upgrades["sword_rate"]["quantity"])
    elif upgrade.id == "sword_damage":
        damage = base_damage * pow(1.15, current_upgrades["sword_damage"]["quantity"])
