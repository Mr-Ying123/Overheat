extends Panel

var populated = false

func populate(x := int()):
	randomize()
	for _Amount in range(x):
		var Triangle = TextureRect.new()
		Triangle.set_deferred("texture",load("res://Triangle.png"))
		$Control.call_deferred("add_child",Triangle)
		Triangle.flip_h = bool( 0.5 < rand_range(0,1))
	populated = true

func chechTriangle(IsFlipped):
	if $Control.get_child_count() > 0:
		if $Control.get_children().front().flip_h == IsFlipped:
			$Control.get_children().front().queue_free()
			return true
		else:
			$Tween.interpolate_property($Control.get_children().front(),"modulate",Color.white,Color.orangered,0.1,Tween.TRANS_EXPO)
			$Tween.start()
			return false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_right"):
		chechTriangle(true)
	if Input.is_action_just_pressed("ui_left"):
		chechTriangle(false)

signal complete
func _process(_delta):
	if populated and $Control.get_child_count() == 0 and $Timer.is_stopped():
		$Timer.start()
		yield($Timer,"timeout")
		emit_signal("complete")
		populated = false

