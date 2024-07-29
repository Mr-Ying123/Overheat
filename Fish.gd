extends RigidBody2D

var power = 900000
var clicks = 0

signal Complete
func _process(_delta):
	if in_area and Input.is_action_just_pressed("ui_accept") and modulate.a > 0.5:
		randomize()
		clicks += 1
		apply_impulse(get_local_mouse_position(),Vector2(get_local_mouse_position().direction_to(position).rotated(deg2rad(rand_range(15,0)) * power)))
	if clicks >= 5:
		in_area = false
		clicks = 0
		emit_signal("Complete")

var in_area = false
func _on_Fish_mouse_entered():
	in_area = true


func _on_Fish_mouse_exited():
	in_area = false
