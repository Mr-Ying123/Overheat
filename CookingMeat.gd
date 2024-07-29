extends "res://TaskBase.gd"

var temp = 0

func activate():
	Global.camera.zoom_in(position)
	
	$AnimationPlayer.play("Reset")
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play_backwards("Hide")
	yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("Cook")
	yield($CanvasLayer/Pan,"Complete")
	$AnimationPlayer.play("Hide")
	
	Global.camera.zoom_out()
	Global.players_ingredients_set("res://Egg.png")
	reactivate_player()

