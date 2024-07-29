extends Sprite

var active = false
func activate():
	randomize()
	active = true
	$Icon3.position.y = rand_range(-30,30)
	$AnimationPlayer.play_backwards("hide")
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("Clicker")

signal Complete
func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept") and active:
		if abs($Icon3.position.y - $Icon2.position.y) < 5.01:
			$AnimationPlayer.play("hide")
			emit_signal("Complete")
			active = false
