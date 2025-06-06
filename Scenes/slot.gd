extends PanelContainer

@export var item: Weapon:
	set(value):
		if item != null and item.has_method("reset"):
			item.reset()
			
		item = value
		$TextureRect.texture = value.texture
		$CoolDown.wait_time = value.cooldown
		item.slot = self

func _physics_process(delta: float) -> void:
	if item != null and item.has_method("update"):
		item.update(delta)

func _on_cool_down_timeout() -> void:
	if item:
		$CoolDown.wait_time = item.cooldown
		item.activate(owner, owner.nearest_enemy, get_tree())
