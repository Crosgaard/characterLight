extends "res://scenes/levels/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.current_scene = "res://scenes/levels/level_3.gd"
	#Tilføj "Game Won" screen
	#next_level = "res://scenes/levels/winsmth.tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_win_area_body_entered(body):
	get_tree().change_scene_to_file("res://scenes/Win Screen/win_screen.tscn")
	pass # Replace with function body.
