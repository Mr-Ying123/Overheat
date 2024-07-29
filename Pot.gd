extends "res://TaskBase.gd"

var temp = 0

func activate():
	Global.camera.zoom_in(position)
	$SkillBar.activate()
	yield($SkillBar3,"Complete")
	Global.deliver()
	Global.camera.zoom_out()
	reactivate_player()
	temp = 0

func _ready():
	var _x = $SkillBar.connect("Complete",$SkillBar2,"activate")
	_x = $SkillBar2.connect("Complete",$SkillBar3,"activate")

func _process(delta):
	$ProgressBar.value = temp
	temp += delta / 45
