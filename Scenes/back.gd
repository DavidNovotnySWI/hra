extends Button

func _ready():
	visible = false
	
func _process(delta):
	if get_tree().paused == true and owner.health <= 0 and visible == false:
		visible = true

func _on_pressed():
	get_tree().paused = false
	SaveData.gold += owner.gold
	SaveData.set_and_save()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
