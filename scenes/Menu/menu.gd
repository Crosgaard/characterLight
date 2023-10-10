extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_knap_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_controls_knap_pressed():
	pass
	get_tree().change_scene_to_file("res://scenes/Menu/controls_menu.tscn")


func _on_quit_knap_pressed():
	get_tree().quit()


