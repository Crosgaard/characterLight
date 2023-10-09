extends CanvasLayer

@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar

func _ready():
	Globals.connect("stat_change", update_stat_ui)
	update_stat_ui()

func update_health_ui():
	health_bar.value = Globals.health
	pass

func update_stat_ui():
	update_health_ui()
