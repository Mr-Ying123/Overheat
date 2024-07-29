extends Node2D

func _ready():
	Global.reset_game_state()
func _process(_delta):
	if Global.temp >= 1:
		$AnimationPlayer.play_backwards("InOut")
		yield($AnimationPlayer,"animation_finished")
		var _x = get_tree().change_scene("res://FailMenu.tscn")
	elif Global.Orders_left <= 0:
		if Global.speedrun_time > Global.best_speedrun_time:
			Global.best_speedrun_time = Global.speedrun_time
		$AnimationPlayer.play_backwards("InOut")
		yield($AnimationPlayer,"animation_finished")
		var _x = get_tree().change_scene("res://FailMenu.tscn")
