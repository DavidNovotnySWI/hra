extends TextureButton
 
 
@export var weapon : Weapon:
	set(value):
		weapon = value
		texture_normal = value.texture
		$Label.text = "Lvl " + str(weapon.level + 1)
		$Description.text = value.upgrades[value.level - 1].description
 
 
func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("click") and weapon:
		print(weapon.title)
		weapon.upgrade_item()
		get_parent().close_option()
 
