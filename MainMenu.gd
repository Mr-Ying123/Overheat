extends Control

onready var Game = preload("res://World.tscn")

func _ready():
	var time = Global.best_speedrun_time
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60) / 60
	var hr = fmod(fmod(time,3600 * 60) / 3600,24)
	var dy = fmod(time,12960000) / 86400
	
	var time_passed = "%02d : %02d : %02d : %02d : %03d" % [dy,hr,mins,secs,mils]
	$Label.text = "Best Time: "+time_passed

func _on_Quit_pressed():
	$AnimationPlayer.play_backwards("InOut")
	yield($AnimationPlayer,"animation_finished")
	get_tree().quit()

func _on_Play_pressed():
	$AnimationPlayer.play_backwards("InOut")
	yield($AnimationPlayer,"animation_finished")
	var _x = get_tree().change_scene_to(Game)
