extends Node2D
class_name LevelParent

var next_level: String

func _ready():
	Globals.current_scene = get_tree().current_scene.scene_file_path

func _on_kill_barrier_body_entered(body):
	if(body.name == "Player"):
		$Player.die()

func _on_level_change_area_body_entered(_body):
	Globals.player_movable = false
	Globals.player_vulnerable = false
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.5)
	Globals.player_invulnerable_timer()
	#TransitionLayer.change_scene(next_level)
