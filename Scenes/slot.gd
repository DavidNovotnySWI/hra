extends PanelContainer

@export var weapon: Weapon:
	set(value):
		weapon = value
		$TextureRect.texture = value.texture
		$CoolDown.wait_time = value.cooldown


func _on_cool_down_timeout() -> void:
	if weapon:
		$CoolDown.wait_time = weapon.cooldown
		weapon.activate(owner, owner.nearest_enemy, get_tree())
