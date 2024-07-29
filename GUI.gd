extends Control

func _process(_delta):
	$CenterContainer/RichTextLabel.bbcode_text = "[center]"+str(Global.Orders_left)+" Orders left"
