extends Node2D

func activate():
	pass

func reactivate_player():
	yield(get_tree().create_timer(0.1),"timeout")
	Global.player.pause_mode = Node.PAUSE_MODE_INHERIT
	Global.player.ChageState(Global.player.states.normal)
