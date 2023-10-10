extends Node

signal stat_change

var current_scene: String = "res://scenes/Menu/controls_menu.tscn"

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

const DASH_SLOW_TIME: float = 1000
var dash_slowing: bool = false

var dash_time_used: float = 0:
	set(value):
		dash_time_used = value
		stat_change.emit()



