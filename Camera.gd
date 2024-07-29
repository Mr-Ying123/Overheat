extends Camera2D

onready var maxzoom = zoom
func _ready():
	Global.camera = self

func zoom_in(Zoom_position : Vector2 , zoom_at_point := Vector2(1.375,1.375)):
	var time = 0.7
	$Tween.interpolate_property(self,"position",position,
	Zoom_position,time,Tween.TRANS_QUAD)
	$Tween.start()
	
	$Tween2.interpolate_property(self,"zoom",zoom,
	zoom_at_point,time,Tween.TRANS_QUAD)
	$Tween2.start()

func zoom_out():
	var time = 0.7
	$Tween.interpolate_property(self,"position",position,
	Vector2.ZERO,time,Tween.TRANS_QUAD)
	$Tween.start()
	
	$Tween2.interpolate_property(self,"zoom",zoom,
	maxzoom,time,Tween.TRANS_QUAD)
	$Tween2.start()

func can_be_moved():
	return Vector2(0,Global.player.global_position.y).distance_to(Vector2.ZERO) > 402 and zoom == maxzoom


export(NodePath) var Trans
func _process(_delta):
	smoothing_enabled = can_be_moved()
	if can_be_moved():
		if get_node(Trans).remote_path != get_path():
			$Tween3.interpolate_property(get_node(Trans),"global_position",global_position,Global.player.global_position,0.25)
			$Tween3.start()
			get_node(Trans).set_deferred("remote_path" , get_path() )
	elif Vector2(0,Global.player.global_position.y).distance_to(Vector2.ZERO) < 250 and zoom == maxzoom:
		global_position = lerp(global_position,Vector2.ZERO,0.5)
		if get_node(Trans).remote_path != get_node(Trans).get_path():
			get_node(Trans).remote_path = get_node(Trans).get_path()
