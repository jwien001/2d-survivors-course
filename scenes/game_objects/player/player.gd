extends CharacterBody2D
class_name Player

@export var arena_time_manager: ArenaTimeManager

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals

var num_colliding_bodies = 0
var base_speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
    base_speed = $VelocityComponent.max_speed

    arena_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)
    $CollisionArea2D.body_entered.connect(_on_body_entered)
    $CollisionArea2D.body_exited.connect(_on_body_exited)
    damage_interval_timer.timeout.connect(_on_damager_interval_timer_timeout)
    health_component.health_changed.connect(_on_health_changed)
    GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added)
    update_health_display(1)


func get_health_component():
    return health_component


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var movement_vector = get_movement_vector()
    var direction = movement_vector.normalized()
    velocity_component.accelerate_in_direction(direction)
    velocity_component.move(self)

    if movement_vector.x != 0 || movement_vector.y != 0:
        animation_player.play("walk")
    else:
        animation_player.play("RESET")

    var move_sign = sign(movement_vector.x)
    if move_sign != 0:
        visuals.scale.x = move_sign


func get_movement_vector() -> Vector2:
#    var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
#    var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#    return Vector2(x_movement, y_movement)
    return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func check_deal_damage():
    if num_colliding_bodies == 0 or not damage_interval_timer.is_stopped(): return
    health_component.damage(1)
    damage_interval_timer.start()


func update_health_display(health_percent: float):
    health_bar.value = health_percent


func _on_body_entered(other_body: Node2D):
    num_colliding_bodies += 1
    check_deal_damage()


func _on_body_exited(other_body: Node2D):
    num_colliding_bodies -= 1


func _on_damager_interval_timer_timeout():
    check_deal_damage()


func _on_health_changed(delta, current_health: float, max_health: float):
    var health_percent = min(current_health / max_health, 1)
    update_health_display(health_percent)

    if delta < 0:
        $HitAudioStreamPlayer2D.play()


func _on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
    if ability_upgrade is Ability:
        abilities.add_child((ability_upgrade as Ability).ability_controller_scene.instantiate())
    elif ability_upgrade.id == "player_speed":
        velocity_component.max_speed = base_speed * pow(1.1, current_upgrades["player_speed"]["quantity"])


func _on_arena_difficulty_increased(difficulty: int):
    var is_thirty_second_interval = (difficulty % 6) == 0
    var health_regen_amt = MetaProgression.get_upgrade_count("health_regen")
    if is_thirty_second_interval and health_regen_amt > 0:
        health_component.damage(-1 * MetaProgression.get_upgrade_count("health_regen"))
