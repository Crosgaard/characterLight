extends CanvasLayer

@onready var dash_bar: TextureProgressBar = $DashBar/TextureDashBar

func _ready():
	Globals.connect("stat_change", update_stat_ui)
	update_stat_ui()

func update_dash_bar():
	dash_bar.value = 100 - min(int(Globals.dash_time_used/ Globals.DASH_SLOW_TIME * 100), 100)
	if dash_bar.value > 100 or !Globals.can_dash:
		dash_bar.modulate = Color(0,0,0,0)
	else:
		dash_bar.modulate = Color(0,0,0,1)
	pass

func update_stat_ui():
	update_dash_bar()
