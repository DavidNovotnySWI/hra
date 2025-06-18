extends PanelContainer

@onready var title_label = $DeathPanel/TitleLabel
@onready var time_label = $DeathPanel/TimeLabel
@onready var gold_label = $DeathPanel/GoldLabel
@onready var level_label = $DeathPanel/LevelLabel

var shown := false
var elapsed_time := 0.0

func _ready():
	visible = false
	
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0, 0, 0.8)  # tmavé průhledné pozadí
	stylebox.set_border_width_all(2)
	stylebox.border_color = Color(1, 1, 1)  # bílý rámeček
	stylebox.corner_radius_top_left = 8
	stylebox.corner_radius_top_right = 8
	stylebox.corner_radius_bottom_left = 8
	stylebox.corner_radius_bottom_right = 8

	add_theme_stylebox_override("panel", stylebox)

func _process(delta):
	var player := get_tree().get_first_node_in_group("player")
	if not player:
		return

	if not get_tree().paused:
		elapsed_time += delta

	if get_tree().paused and player.health <= 0 and not shown:
		shown = true
		show_death_screen()

func show_death_screen():
	visible = true

	var player := get_tree().get_first_node_in_group("player")
	var spawner := get_tree().get_first_node_in_group("spawner")

	var minutes := 0
	var seconds := 0

	if spawner:
		minutes = spawner.minute
		seconds = spawner.second

	title_label.text = "💀 You Died!"
	time_label.text = "🕒 Time survived: %02d:%02d" % [minutes, seconds]
	gold_label.text = "💰 Gold collected: %d" % player.gold
	level_label.text = "🏆 Level reached: %d" % player.level
