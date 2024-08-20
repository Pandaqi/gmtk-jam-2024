extends Node

signal game_over(we_won:bool)
signal tooltip(show:bool, mod:ModuleTooltip)
signal feedback(pos:Vector2, txt:String, convert:bool)
signal player_state_changed(new_state:Player.PlayerState)

func _ready() -> void:
	add_background_music()

func add_background_music() -> void:
	if OS.is_debug_build() and Global.config.debug_disable_sound: return
	var a = AudioStreamPlayer.new()
	a.stream = preload("res://game_loop/globals/theme_song_beepy.mp3")
	a.volume_db = -18
	a.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(a)
	a.play()
