extends Resource
class_name Pickups

@export var title : String
@export var icon : Texture2D
@export_multiline var description : String
@export var sound : AudioStream

var player_reference: CharacterBody2D

func activate():
	SoundManager.play_sfx(sound)
	#print(title + "picked up.")
