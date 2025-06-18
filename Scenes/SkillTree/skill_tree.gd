extends Panel
 
var skill_tree
var total_stat : Stats
 
func _ready():
	load_skill_tree()
 
func load_skill_tree():
	if SaveData.skill_tree == []:
		set_skill_tree()
 
	skill_tree = SaveData.skill_tree
	for branch in get_children():
		for upgrade in branch.get_children():
			upgrade.enabled = skill_tree[branch.get_index()][upgrade.get_index()]
	get_total_stats()
 
func set_skill_tree():
	skill_tree = []
	for each_branch in get_children():
		var branch = []
		for upgrade in each_branch.get_children():
			branch.append(upgrade.enabled)
		skill_tree.append(branch)
 
	SaveData.skill_tree = skill_tree
	SaveData.set_and_save()
 
func add_stats(stat):
	total_stat.max_health += stat.max_health
	total_stat.recovery += stat.recovery
	total_stat.armor += stat.armor
	total_stat.movement_speed += stat.movement_speed
	total_stat.might += stat.might
	total_stat.area += stat.area
	total_stat.magnet += stat.magnet
	total_stat.growth += stat.growth
 
func get_total_stats():
	total_stat = Stats.new()
	for branch in get_children():
		for upgrade in branch.get_children():
			if upgrade.enabled:
				add_stats(upgrade.skill.stats)
	# Ulož jen bonusy ze skillů (ne výchozí hodnoty)
	Persistence.bonus_stats = total_stat

	# Připrav součet základních hodnot pro zobrazení
	var display_stats := Stats.new()
	display_stats.max_health = total_stat.max_health + 100
	display_stats.recovery = total_stat.recovery + 0
	display_stats.armor = total_stat.armor + 0
	display_stats.movement_speed = total_stat.movement_speed + 150
	display_stats.might = total_stat.might + 1.5
	display_stats.area = total_stat.area + 0
	display_stats.magnet = total_stat.magnet + 0
	display_stats.growth = total_stat.growth + 1

	# Zobraz ve stats labelu
	var stats_label := get_tree().current_scene.find_child("Stats", true, false)
	if stats_label and stats_label.has_method("update_stats_display"):
		stats_label.update_stats_display(display_stats)
	
