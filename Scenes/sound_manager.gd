extends Node2D

var last_played : Dictionary = {}
var sfx_players : Dictionary = {}

const COOLDOWN := 0.1
const REPEAT_VOLUME_DB := -15

func play_sfx(sfx: AudioStream, force_play: bool = false) -> void:
	if not sfx:
		return

	var now = Time.get_ticks_msec() / 1000.0
	var repeated := false

	if not force_play:
		if sfx in last_played and now - last_played[sfx] < COOLDOWN:
			repeated = true

	last_played[sfx] = now

	# Každý zvuk má svůj vlastní player (pooling)
	var player: AudioStreamPlayer
	if sfx_players.has(sfx) and not force_play:
		player = sfx_players[sfx]
	else:
		player = AudioStreamPlayer.new()
		add_child(player)
		player.stream = sfx
		player.bus = "SFX"
		if not force_play:
			sfx_players[sfx] = player

	# Přehrávej (s ohledem na force)
	if player.playing:
		if force_play:
			# nech hrající zvuk být, pustíme nový
			pass
		else:
			player.stop()

	player.volume_db = 0 if force_play else (REPEAT_VOLUME_DB if repeated else 0)
	player.play()

	if force_play:
		# jednorázový zvuk – smaž po dohrání
		player.finished.connect(player.queue_free)
