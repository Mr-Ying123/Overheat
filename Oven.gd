extends "res://TaskBase.gd"

var temp = 0

func activate():
	Global.camera.zoom_in(position)
	$SkillLine.activate()
	yield($SkillLine,"Complete")
	Global.camera.zoom_out()
	Global.players_ingredients_set("res://bread.png")
	reactivate_player()

