class_name TutorialSprite extends Node2D

@onready var bg : Sprite2D = $BG
@onready var sprite : Sprite2D = $Sprite2D
@onready var label : Label = $Label

signal done()

func _ready() -> void:
	self.modulate.a = 0.0
	
	var dur := 5.0
	var tw := get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.5)
	await get_tree().create_timer(dur).timeout
	done.emit()
	
	var tw_remove := get_tree().create_tween()
	tw_remove.tween_property(self, "modulate:a", 0.0, 2.0)
	await tw_remove.finished
	self.queue_free()

func set_base_tutorial(num:int) -> void:
	sprite.set_visible(false)
	label.set_visible(false)
	bg.set_frame(num)

func set_tool(tt:ToolType) -> void:
	bg.set_frame(3)
	sprite.set_frame(tt.frame)
	label.set_text(tt.desc)
	
