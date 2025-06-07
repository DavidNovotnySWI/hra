extends TextureButton

@export var skill: Skill

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
			

func _ready():
	if skill:
		texture_normal = skill.texture

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
		#SaveData.set_and_save()
		
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
