extends CanvasLayer

signal transitioned_halfway

var skip_emit = false


func transition(custom_speed: float = 1.0):
    $ColorRect.visible = true
    $AnimationPlayer.play("default", -1, custom_speed)
    await $AnimationPlayer.animation_finished
    transitioned_halfway.emit()
    $AnimationPlayer.play("default", -1, -custom_speed, true)
    await $AnimationPlayer.animation_finished
    $ColorRect.visible = false

