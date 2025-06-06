extends CharacterBody2D
@onready var anim := $AnimatedSprite2D
@export var hurt_sound : AudioStream
@export var death_sound: AudioStream
@export var lvl_up_sound: AudioStream

var damage_sound_timer := 0.0
const DAMAGE_SOUND_COOLDOWN := 0.6  # sekundy

var health : float = 100.0 :
	set(value):
		health = max(value,0)
		%Health.value = value
		%HeatlhBarUI.value = value
		if health <=0:
			anim.play("death")
			SoundManager.play_sfx(death_sound)
			get_tree().paused = true
 
var movement_speed : float = 150:
	set(value):
		movement_speed = value
		%MovementSpeed.text = str(value)

var max_health : float = 100 :
	set(value):
		max_health = value
		%Health.max_value = value
		#%Health.text = "MH : " + str(value)
var recovery : float = 0:
	set(value):
		recovery = value
		%Recovery.text = str(value)
var armor : float = 0:
	set(value):
		armor = value
		%Armor.text =  str(value)
var might : float = 1.5:
	set(value):
		might = value
		%Might.text =  str(value)
	
var area : float = 0
var magnet : float  = 0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 50 + value
var growth : float = 1


var nearest_enemy
var nearest_enemy_distance : float = 150 + area
 
var level : int = 1:
	set(value):
		level = value
		%Level.text = str(value)
		%Options.show_options()
		SoundManager.play_sfx(lvl_up_sound)
		if level == 2:
			%XP.max_value = 10
		elif level == 3:
			%XP.max_value = 20
		elif level == 4:
			%XP.max_value = 30
		elif level == 5:
			%XP.max_value = 40
		elif level >= 6:
			#%XP.max_value = 30
			%XP.max_value = %XP.max_value * 1.2

var distance_in_pixel : float

var gold : int = 0:
	set(value):
		gold = value
		%Gold.text = "Gold: " + str(value)
	
var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0


func _ready():
	Persistence.gain_bonus_stats(self)
 
func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation
	else:
		nearest_enemy_distance = 150 + area
		nearest_enemy = null
	
	var initial_position = position
	velocity = Input.get_vector("left","right","up","down") * movement_speed
	move_and_collide(velocity * delta)
	_update_animation(velocity)
	distance_in_pixel += position.distance_to(initial_position)
	
	if distance_in_pixel >= 20:
		distance_in_pixel -= 20
		ParticleFx.add_effect("dust", position + Vector2(0,15))
	
	damage_sound_timer -= delta
	check_XP()
	health += recovery * delta
 
func take_damage(amount):
	var real_damage = max(amount * (armor/(amount + armor)), 1)
	if real_damage <= 0:
		return

	health -= real_damage

	# přehraj zvuk maximálně jednou za 0.3s
	if damage_sound_timer <= 0.0:
		SoundManager.play_sfx(hurt_sound, true)
		damage_sound_timer = DAMAGE_SOUND_COOLDOWN

 
func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1
 
 
func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth

func _on_timer_timeout():
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
	
func _on_self_damage_body_entered(body):
	take_damage(body.damage)

func _on_magnet_area_entered(area):
	if area.has_method("follow"):
		area.follow(self)

func gain_gold(amount):
	gold += amount
		
func _update_animation(dir: Vector2) -> void:
	# 1) Smrt
	#if health <= 0:
	#	anim.play("death")
	#	return

	# 2) Nehýbu-li se → idle ve správném natočení
	if dir == Vector2.ZERO:
		anim.play("idle")
		return

	if abs(dir.x) > abs(dir.y):
		anim.play("walk_right")                 # vždy stejné klipy
		anim.flip_h = dir.x < 0                 # zrcadlit pro ←
		anim.flip_v = false
	else:
		anim.play("walk_up")                    # stejné klipy
