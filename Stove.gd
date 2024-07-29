extends "res://TaskBase.gd"

func activate():
	$AnimationPlayer.play_backwards("Hide")
	Global.camera.zoom_in(position)
	$SkillBlock.populate(4)
	yield($SkillBlock,"complete")
	$AnimationPlayer.play("Hide")
	Global.camera.zoom_out()
	Global.players_ingredients_set("res://Chease.png")
	reactivate_player()

