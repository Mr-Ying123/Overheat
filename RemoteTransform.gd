extends RemoteTransform2D

var charge = 1
func _process(_delta):
	position.y = 50 * charge 
	if get_parent().global_position.y < 0:
		charge = -3
	else:
		charge = 1
