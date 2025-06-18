extends Label

func update_stats_display(stats: Stats) -> void:
	var text := "Stats\n"
	text += "HP: +%s\n" % stats.max_health
	text += "Regen: +%s\n" % stats.recovery
	text += "Armor: +%s\n" % stats.armor
	text += "Speed: +%s\n" % stats.movement_speed
	text += "Might: +%s\n" % stats.might
	text += "Area: +%s\n" % stats.area
	text += "Magnet: +%s\n" % stats.magnet
	text += "EXP: +%s" % stats.growth

	self.text = text.strip_edges()
