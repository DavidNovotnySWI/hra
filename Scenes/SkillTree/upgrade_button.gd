extends TextureButton

@export var skill: Skill
var default_material : Material

var enabled : bool =false:
	set(value):
		enabled = value
		$Panel.show_behind_parent = value
		
		if value:
			$Outline.add_point(Vector2(0,-1))
			$Outline.add_point(Vector2(40,-1))
			$Outline.add_point(Vector2(40,39))
			$Outline.add_point(Vector2(0,39))
		if value and get_index() != 0:
			$Connection.add_point(Vector2(20,20) + initial_modifier())
			$Connection.add_point(get_parent().get_child(get_index() - 1)
			.position - position + Vector2(20,20) + final_modifier())
		if not enabled and is_upgradable() and SaveData.gold >= skill.cost:
			$Outline.clear_points()
			$Outline.material = null
			$Outline.default_color = Color(0.3, 1.0, 0.3)  # zelená
			$Outline.add_point(Vector2(0, -1))
			$Outline.add_point(Vector2(40, -1))
			$Outline.add_point(Vector2(40, 39))
			$Outline.add_point(Vector2(0, 39))
			$Outline.add_point(Vector2(0, -1))

#func _ready():
#	if skill:
#		texture_normal = skill.texture
func _ready():
	default_material = $Outline.material
	if skill:
		texture_normal = skill.texture

	# Tooltip panel
	var tooltip_panel = PanelContainer.new()
	tooltip_panel.name = "TooltipPanel"
	tooltip_panel.visible = false
	tooltip_panel.position = Vector2(45, 0)
	tooltip_panel.z_index = 100  # zajistí zobrazení nad ostatními

	# Styl
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.1, 0.1, 0.1, 0.9)  # tmavé pozadí s průhledností
	stylebox.border_color = Color(1, 1, 1)        # bílý rámeček
	stylebox.set_border_width_all(2)
	tooltip_panel.add_theme_stylebox_override("panel", stylebox)

	# Label pro popis
	var label = RichTextLabel.new()
	label.name = "TooltipLabel"
	label.text = _get_skill_description()
	label.bbcode_enabled = true
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.fit_content = true
	label.set_custom_minimum_size(Vector2(150, 0))  # šířka tooltipu
	tooltip_panel.add_child(label)

	add_child(tooltip_panel)

	var stats_label = get_tree().current_scene.get_node("Stats")
	if stats_label:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			stats_label.update_stats_display(player)
	# Signály
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	var tooltip = get_node("TooltipPanel")
	var label = tooltip.get_node("TooltipLabel")
	label.text = _get_skill_description()
	label.reset_size()  # << resetuje velikost labelu
	tooltip.reset_size()  # << resetuje velikost panelu!
	tooltip.global_position = get_global_mouse_position() + Vector2(16, 16)
	tooltip.visible = true

func _on_mouse_exited():
	get_node("TooltipPanel").visible = false

func _get_skill_description() -> String:
	if not skill:
		return ""

	var desc = "[b]" + skill.name + "[/b]\n"
	desc += "Cena: " + str(skill.cost) + " gold\n"

	if skill.stats.max_health != 0:
		desc += "❤️ HP: +" + str(skill.stats.max_health) + "\n"
	if skill.stats.recovery != 0:
		desc += "💊 Regenerace: +" + str(skill.stats.recovery) + "\n"
	if skill.stats.armor != 0:
		desc += "🛡️ Armor: +" + str(skill.stats.armor) + "\n"
	if skill.stats.movement_speed != 0:
		desc += "🏃‍♂️ Rychlost: +" + str(skill.stats.movement_speed) + "\n"
	if skill.stats.might != 0:
		desc += "💥 Síla: +" + str(skill.stats.might) + "\n"
	if skill.stats.area != 0:
		desc += "📏 Dosah: +" + str(skill.stats.area) + "\n"
	if skill.stats.magnet != 0:
		desc += "🧲 Magnet: +" + str(skill.stats.magnet) + "\n"
	if skill.stats.growth != 0:
		desc += "🌱 Zisk EXP: +" + str(skill.stats.growth) + "\n"

	if not enabled:
		if not is_upgradable():
			desc += "[color=red]Musíš nejprve odemknout předchozí skill.[/color]\n"
		elif SaveData.gold < skill.cost:
			desc += "[color=red]Nemáš dostatek zlata.[/color]\n"

	return desc

func is_upgradable() -> bool:
	if get_index() == 0:
		return true
	elif  get_index() > 0:
		if get_parent().get_child(get_index() - 1).enabled == true:
			return true
		else:
			return false

	return false

func _on_pressed() -> void:
	if skill.cost <= SaveData.gold and is_upgradable() and not enabled:
		SoundManager.play_sfx(load("res://assets/sound/rpg/rpg/wave/utility/utility1.wav"))
		SaveData.gold -= skill.cost
		enabled = true
		get_parent().get_parent().set_skill_tree()
		get_parent().get_parent().get_total_stats()

		$Outline.clear_points()
		$Outline.material = default_material
		$Outline.add_point(Vector2(0,-1))
		$Outline.add_point(Vector2(40,-1))
		$Outline.add_point(Vector2(40,39))
		$Outline.add_point(Vector2(0,39))
		#SaveData.set_and_save()
		
		var next_index := get_index() + 1
		var siblings := get_parent().get_children()
		if next_index < siblings.size():
			var next_button := siblings[next_index]
			if not next_button.enabled and next_button.is_upgradable() and SaveData.gold >= next_button.skill.cost:
				var outline := next_button.get_node("Outline")
				outline.clear_points()
				outline.material = null
				outline.default_color = Color(0.3, 1.0, 0.3)  # zelená
				outline.add_point(Vector2(0, -1))
				outline.add_point(Vector2(40, -1))
				outline.add_point(Vector2(40, 39))
				outline.add_point(Vector2(0, 39))
				outline.add_point(Vector2(0, -1))
		
func initial_modifier() -> Vector2:
	var difference = get_parent().get_child(get_index() - 1).position - position
	var modification: Vector2 = Vector2.ZERO
	
	if difference.x < 0:
		modification += Vector2(-20,0)
	elif difference.x > 0:
		modification += Vector2(20,0)
		
	if difference.y < 0:
		modification += Vector2(0,-20)
	if difference.y > 0:
		modification += Vector2(0,20)
		
	return modification 

func final_modifier() -> Vector2:
	var difference = get_parent().get_child(get_index() - 1).position - position
	var modification: Vector2 = Vector2.ZERO
	
	if difference.x < 0:
		modification += Vector2(20,0)
	elif difference.x > 0:
		modification += Vector2(-20,0)
		
	if difference.y < 0:
		modification += Vector2(0,20)
	if difference.y > 0:
		modification += Vector2(0,-20)
		
	return modification 
