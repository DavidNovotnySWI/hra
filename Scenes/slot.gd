extends PanelContainer

@export var item: Weapon:
	set(value):
		item = value
		$TextureRect.texture = value.texture
		$CoolDown.wait_time = value.cooldown
		item.slot = self


func _on_cool_down_timeout() -> void:
	if item:
		$CoolDown.wait_time = item.cooldown
		item.activate(owner, owner.nearest_enemy, get_tree())
