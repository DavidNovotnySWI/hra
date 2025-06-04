extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer2D

# Při spuštění se sám "zachová" přes scény
func _ready():
	if not Engine.is_editor_hint():
		if get_parent() == null:
			get_tree().get_root().add_child(self)
			set_owner(null)  # odpoj od scény
			name = "MusicManager"
		set_process(false)

# Spustí skladbu (s případným přepnutím)
func play_music(stream: AudioStream, volume_db: float = 0.0, loop: bool = true):
	if player.stream == stream and player.playing:
		return  # nezněníme, pokud už hraje

	player.stop()
	player.stream = stream
	player.volume_db = volume_db
	player.loop = loop
	player.play()

# Vypnutí / pauza
func stop_music():
	player.stop()

func pause_music():
	player.stream_paused = true

func resume_music():
	player.stream_paused = false
