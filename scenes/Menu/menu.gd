extends Control

var master_bus = AudioServer.get_bus_index("Master")

func _on_start_knap_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_controls_knap_pressed():
	pass
	get_tree().change_scene_to_file("res://scenes/Menu/controls_menu.tscn")

func _on_quit_knap_pressed():
	get_tree().quit()




func _on_music_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
