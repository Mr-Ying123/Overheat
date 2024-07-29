extends Sprite


signal Complete
func _on_Area2D_body_entered(body):
	if body.is_in_group("Meat"):
		emit_signal("Complete")

