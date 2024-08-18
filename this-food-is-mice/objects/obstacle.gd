class_name Obstacle extends StaticBody2D

@onready var visuals : ModuleVisualsObstacle = $Visuals
@onready var bite_receiver : ModuleBiteReceiver = $BiteReceiver
@onready var label_debug : Label = $LabelDebug

var tool : ToolType
var dead := false

signal died(o:Obstacle)

func activate() -> void:
	bite_receiver.activate()
	visuals.activate()
	label_debug.set_visible(OS.is_debug_build() and Global.config.debug_labels)

func set_tool(tt:ToolType) -> void:
	tool = tt
	var title := tool.title if tt != null else "NULL"
	label_debug.set_text(title)

func on_mouse_arrived(m:Mouse) -> void:
	pass

func kill() -> void:
	if dead: return
	
	dead = true
	died.emit(self)
	self.queue_free()
