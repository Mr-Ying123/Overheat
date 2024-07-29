extends "res://TaskBase.gd"

onready var Fish = $CanvasLayer/Fish
func activate():
	$AnimationPlayer.play_backwards("Hide")
	Global.camera.zoom_in(position)
	yield(Fish,"Complete")
	$AnimationPlayer.play("Hide")
	Global.camera.zoom_out()
	Global.players_ingredients_set("res://fillet.png")
	reactivate_player()

