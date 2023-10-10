extends "res://scenes/levels/level.gd"

func _ready():
	Globals.current_scene = "res://scenes/levels/level_2.gd"
	
	next_level = "res://scenes/levels/level_3.tscn"
