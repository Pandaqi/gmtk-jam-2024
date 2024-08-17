class_name UIElement extends Node2D

@export var frame := 0
@onready var sprite : Sprite2D = $Sprite2D
@onready var label : Label = $Label

func _ready() -> void:
	sprite.set_frame(frame)

func update(txt:String) -> void:
	label.set_text(txt)
