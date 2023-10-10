extends CanvasLayer

@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var dash_bar: TextureProgressBar = $DashBar/TextureDashBar

func _ready():
	Globals.connect("stat_change", update_stat_ui)
	update_stat_ui()

func update_dash_bar():
	dash_bar.value = min(int(Globals.dash_time_used/ Globals.DASH_SLOW_TIME * 100), 100)
	if dash_bar.value < 1:
		dash_bar.modulate = Color(0,0,0,0)
	else:
		dash_bar.modulate = Color(0,0,0,1)
	pass

func update_health_ui():
	health_bar.value = Globals.health
	pass

func update_stat_ui():
	update_health_ui()
	update_dash_bar()
