class_name ModuleVisualsPlayer extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var tool_anchor : Node2D = $ToolAnchor
@onready var tool_sprite : Sprite2D = $ToolAnchor/Sprite2D
@export var tool_switcher : ModuleToolSwitcher
@export var mover : ModuleMover
@onready var anim_player : AnimationPlayer = $AnimationPlayer

@export var prog_data : ProgressionData

var base_scale := 1.0
var leveling_up := false
var slamming := false

signal done_slamming()

func activate() -> void:
	tool_switcher.tool_switched.connect(on_tool_switched)
	tool_switcher.tool_used.connect(on_tool_used)
	prog_data.level_changed.connect(on_level_changed)
	mover.moved.connect(on_moved)
	mover.stopped.connect(on_stopped)
	
	base_scale = Global.config.player_starting_scale
	set_scale(Vector2.ONE * base_scale)

func on_level_changed(new_level:int) -> void:
	var at_max := base_scale >= Global.config.player_max_scale
	if at_max: return
	
	var was_visible := is_visible()
	get_tree().paused = true
	leveling_up = true
	set_visible(true)
	
	var old_scale := self.scale
	
	var inc := Global.config.player_scale_increase_per_level
	base_scale = min(Global.config.player_starting_scale + (new_level+1)*inc, Global.config.player_max_scale)
	
	var new_scale := base_scale * Vector2.ONE
	
	print(base_scale)
	print(new_scale)
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(self, "scale", new_scale, 0.1)
	tw.tween_property(self, "scale", old_scale, 0.1)
	tw.tween_property(self, "scale", new_scale, 0.1)
	tw.tween_property(self, "scale", old_scale, 0.1)
	tw.tween_property(self, "scale", new_scale, 0.1)
	tw.tween_property(self, "scale", old_scale, 0.1)
	tw.tween_property(self, "scale", new_scale, 0.1)
	await tw.finished
	
	get_tree().paused = false
	set_visible(was_visible)
	leveling_up = false

func on_tool_used() -> void:
	slamming = true
	anim_player.play("slam")
	await anim_player.animation_finished
	slamming = false
	done_slamming.emit()

func on_moved(vec:Vector2) -> void:
	if leveling_up or slamming: return
	
	var new_scale := 1 if vec.x > 0 else -1
	set_scale(Vector2(new_scale, 1) * base_scale)
	anim_player.play("walk")

func on_stopped() -> void:
	if slamming: return
	anim_player.stop()

func on_tool_switched(tt:ToolType) -> void:
	if tt == null: 
		tool_anchor.set_visible(false)
		return
	tool_anchor.set_visible(true)
	tool_sprite.set_frame(tt.frame)

func get_center() -> Vector2:
	return sprite.global_position
