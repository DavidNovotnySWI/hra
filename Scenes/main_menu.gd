extends Control

func _ready():
	menu()

func _on_upgrades_pressed() -> void:
	skill_trree()

func menu():
	$Menu.show()
	$SkillTree.hide()
	$Gold.hide()
	$Back.hide()

func skill_trree():
	$SkillTree.show()
	$Gold.show()
	$Menu.hide()
	$Back.show()

func _on_back_pressed() -> void:
	menu()
