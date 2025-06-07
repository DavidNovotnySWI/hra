extends Node

@onready var player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var playlist: Array[AudioStream] = []  # přidáš více skladeb do editoru
var current_index: int = 0

func _ready():
	if not Engine.is_editor_hint():
		if get_parent() == null:
			get_tree().get_root().add_child(self)
			set_owner(null)
			name = "MusicManager"

		player.finished.connect(_on_music_finished)  # sleduj konec skladby
		_play_next()

func _on_music_finished():
	_play_next()

func _play_next():
	if playlist.is_empty():
		return

	# sekvenčně:
	current_index = (current_index + 1) % playlist.size()

	var next_stream = playlist[current_index]
	player.stream = next_stream
	player.volume_db = 0.0
	player.play()

func play_music(stream: AudioStream, volume_db: float = 0.0, loop: bool = true):
	if player.stream == stream and player.playing:
		return

	player.stop()
	player.stream = stream
	player.volume_db = volume_db
	player.loop = loop
	player.play()

func stop_music():
	player.stop()

func pause_music():
	player.stream_paused = true

func resume_music():
	player.stream_paused = false
