extends Node

signal stat_change

var current_scene: String = "res://Scenes/Levels/level.tscn"

var score: int = 0:
	set(value):
		score = value
		stat_change.emit()

var prev_score = score

var max_health: int = 5
var player_vulnerable: bool = true

var player_movable: bool = true:
	set(value):
		player_movable = value
		if !value:
			player_movable_timer()

var health = max_health: 
	set(value):
		if value > health:
			health = min(value, 5)
		elif player_vulnerable:
			health = value
			player_vulnerable = false
			player_movable = false
			player_invulnerable_timer()
			player_movable_timer()
		stat_change.emit()

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true

func player_movable_timer():
	await get_tree().create_timer(0.5).timeout
	player_movable = true
	print(player_movable)
