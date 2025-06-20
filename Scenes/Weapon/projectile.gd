extends Area2D
 
var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1
var knockback: float  = 90
var source
 
func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		if "might" in source:
			body.take_damage(damage * source.might)
		else:
			body.take_damage(damage)
		
		body.knockback += direction * knockback


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage)
