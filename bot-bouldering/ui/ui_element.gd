class_name UIElement extends Node2D

@export var frame := 0
@onready var sprite : Sprite2D = $Sprite2D
@onready var label : Label = $Label

func _ready() -> void:
	sprite.set_frame(frame)

func update(txt:String) -> void:
	label.set_text(txt)
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(self, "scale", 1.25*Vector2.ONE, 0.05)
	tw.tween_property(self, "scale", Vector2.ONE, 0.15)
