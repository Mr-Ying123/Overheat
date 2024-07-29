extends "res://TaskBase.gd"


func activate():
	Global.camera.zoom_in(position)
	$SkillBar.activate()
	yield($SkillBar3,"Complete")
	Global.deliver()
	Global.camera.zoom_out()
	reactivate_player()
	Global.temp = 0

func _ready():
	var _x = $SkillBar.connect("Complete",$SkillBar2,"activate")
	_x = $SkillBar2.connect("Complete",$SkillBar3,"activate")

func _process(delta):
	$ProgressBar.value = Global.temp
	Global.temp += delta / 60
