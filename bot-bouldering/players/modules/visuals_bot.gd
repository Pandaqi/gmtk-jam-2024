class_name ModuleVisualsBot extends Node2D

@onready var entity : PlayerBot = get_parent()
@onready var sprite : Sprite2D = $Sprite2D
@onready var shadow : Sprite2D = $Shadow
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@export var faller : ModuleFaller
@onready var audio_player := $AudioStreamPlayer2D

const IDLE_FRAME := 0

func activate() -> void:
	entity.col_shape_changed.connect(on_col_shape_changed)

func on_col_shape_changed(new_radius:float) -> void:
	var new_scale := 2.0 * new_radius / Global.config.sprite_size * Vector2.ONE
	sprite.set_scale(new_scale)
	shadow.set_scale(new_scale)
	
func _process(_dt:float) -> void:
	animate_if_moving()
	keep_shadow_correct()

func keep_shadow_correct() -> void:
	shadow.set_position(to_local(global_position + Vector2.DOWN * Global.config.scale(Global.config.shadow_dist)))

func animate_if_moving() -> void:
	if entity.velocity.length() > 0.003 and not faller.is_falling():
		anim_player.play("walk")
		if not audio_player.is_playing():
			audio_player.pitch_scale = randf_range(0.925, 1.075)
			audio_player.play()
		return
	anim_player.stop()
	sprite.set_frame(IDLE_FRAME)
	
