extends VBoxContainer

@export var weapons : HBoxContainer
@export var passive_items: HBoxContainer
var OptionSlot = preload("res://Scenes/option_slot.tscn")

@export var particles: GPUParticles2D
@export var panel: NinePatchRect

func _ready():
	hide()
	particles.hide()
	panel.hide()
	
func close_option():
	hide()
	particles.hide()
	panel.hide()
	get_tree().paused = false
	
func get_available_resource_in(items)-> Array[Item]:
	var resources : Array[Item] = []
	for item in items.get_children():
		if item.item != null:
			resources.append(item.item)
	return resources
 
func add_option(item) -> int:
	if item.is_upgradable():
		var option_slot = OptionSlot.instantiate()
		option_slot.item = item
		add_child(option_slot)
		return 1
	return 0
 
func show_option():
	var weapons_available = get_available_resource_in(weapons)
	var passive_item_available = get_available_resource_in(passive_items)

	if weapons_available.is_empty() and passive_item_available.is_empty():
		return

	# Vyčisti předchozí volby
	for slot in get_children():
		slot.queue_free()

	# Seznam všech možností, které lze nabídnout
	var all_options : Array[Item] = []

	# 1. Zbraně, které lze vylepšit
	for weapon in weapons_available:
		if weapon.is_upgradable():
			all_options.append(weapon)

		# Pokud je dosaženo max levelu a je potřeba pasivka, přidej "evoluční" nabídku
		if weapon.max_level_reached() and weapon.item_needed in passive_item_available:
			all_options.append(weapon)

	# 2. Pasivní předměty, které lze vylepšit
	for passive_item in passive_item_available:
		if passive_item.is_upgradable():
			all_options.append(passive_item)

	if all_options.is_empty():
		return

	# Zamíchej možnosti a vezmi max 3
	all_options.shuffle()
	var final_options = all_options.slice(0, min(3, all_options.size()))

	# Přidej do UI
	for item in final_options:
		var option_slot = OptionSlot.instantiate()
		option_slot.item = item
		add_child(option_slot)
		
	show()
	particles.show()
	panel.show()
	get_tree().paused = true
	
