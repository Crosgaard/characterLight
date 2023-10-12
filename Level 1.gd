extends "res://scenes/levels/level.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.current_scene = "res://scenes/levels/level_1.tscn"

	next_level = "res://scenes/levels/level_2.tscn"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
