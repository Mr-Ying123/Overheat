extends Control

onready var Game = preload("res://World.tscn")
func _on_Retry_pressed():
	$AnimationPlayer.play_backwards("InOut")
	yield($AnimationPlayer,"animation_finished")
	var _x = get_tree().change_scene_to(Game)

func _on_Quit_pressed():
	$AnimationPlayer.play_backwards("InOut")
	yield($AnimationPlayer,"animation_finished")
	get_tree().quit()
