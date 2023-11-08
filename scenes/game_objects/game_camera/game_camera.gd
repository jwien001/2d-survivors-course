extends Camera2D


const LERP_SMOOTHING = 8
const LERP_OVERSHOOT = 32

var player: Node2D
var target_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
    make_current()
    player = get_tree().get_first_node_in_group("player") as Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    acquire_target()
#    global_position = target_position  # requires Camera2D Position Smoothing to be enabled
    global_position = lerp_overshoot_v(global_position, target_position, lerp_weight(delta), LERP_OVERSHOOT)
#    global_position = global_position.lerp(target_position, lerp_weight(delta)).round()


func acquire_target() -> void:
    if !player: return
    target_position = player.global_position


func lerp_weight(delta) -> float:
    return 1.0 - exp(-delta * LERP_SMOOTHING)


# lerp to overshot target, without overshooting
func lerp_overshoot(from: float, to: float, weight: float, overshoot: float) -> float:
    var d := (to - from) * weight

    if is_zero_approx(d):
        return to

    var s = sign(d)
    var l: float = lerp(from, to + (overshoot * s), weight)

    if s == 1.0:
        l = min(l, to)
    elif s == -1.0:
        l = max(l, to)

    return l


# lerp to overshot target, without overshooting
func lerp_overshoot_v(from: Vector2, to: Vector2, weight: float, overshoot: float) -> Vector2:
    var x = lerp_overshoot(from.x, to.x, weight, overshoot)
    var y = lerp_overshoot(from.y, to.y, weight, overshoot)

    return Vector2(x,y)
