extends CharacterBody2D
 
@export var player_reference : CharacterBody2D
var damage_popup_node = preload("res://Scenes/damage.tscn")
var direction : Vector2
var speed : float = 75
var damage : float
var knockback : Vector2
var separation : float

var drop = preload("res://Scenes/pickups.tscn")
 
var health : float:
	set(value):
		health = value
		if health <= 0:
			drop_item()
			#queue_free()
 
var elite : bool = false:
	set(value):
		elite = value
		if value:
			$Sprite2D.material = ShaderPool.outline
			scale = Vector2(1.5,1.5)
 
var type : Enemy:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		damage = value.damage
		health = value.health
 
 
func _physics_process(delta):
	check_separation(delta)
	knockback_update(delta)
 
func check_separation(_delta):
	separation = (player_reference.position - position).length()
 
	if separation < player_reference.nearest_enemy_distance:
		player_reference.nearest_enemy = self
 
	if separation >= 800 and not elite:
		queue_free()
	
 
func knockback_update(delta):
	velocity = (player_reference.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50
 
 
func damage_popup(amount):
	var popup = damage_popup_node.instantiate()
	popup.text = str(amount)
	popup.position = position + Vector2(-50,-25)
	get_tree().current_scene.add_child(popup)
 
 
func take_damage(amount):
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(3, 0.25, 0.25), 0.2)
	tween.chain().tween_property($Sprite2D, "modulate", Color(1, 1, 1), 0.2)
	tween.bind_node(self)
 
	damage_popup(amount)
	health -= amount
	
func drop_item():
	if type.drops.size() == 0:
		return
	
	var item = type.drops.pick_random()
	
	# z elite monster padaji goldy
	if elite:
		item = load("res://Resources/PickUps/Gold.tres")
		
	var item_to_drop = drop.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	
	get_tree().current_scene.call_deferred("add_child", item_to_drop)
	
	disable()
	await  set_shader()
	queue_free()
	
func set_shader_value(value: float):
	$Sprite2D.material.set_shader_parameter("dissolve_value", value)
	
func set_shader():
	$Sprite2D.material = ShaderPool.burn.duplicate()
	$Sprite2D.material.set_shader_parameter("dissolve_texture", type.texture)
	
	var tween = get_tree().create_tween()
	tween.tween_method(set_shader_value, 1.0, 0.0, 1)
	await tween.finished
	
func disable():
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	
