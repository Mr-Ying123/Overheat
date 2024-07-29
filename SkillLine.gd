extends Node2D

var active = false
func activate():
	randomize()
	active = true
	$AnimationPlayer.play_backwards("hide")
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("Up")

signal Complete
func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept") and active:
		if abs($Win.position.y - $Sprite5.position.y) < 16:
			$AnimationPlayer.play("hide")
			emit_signal("Complete")
			active = false
