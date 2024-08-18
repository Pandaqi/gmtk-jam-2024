class_name Mouse extends CharacterBody2D

@onready var visuals : ModuleVisualsMouse = $Visuals
@onready var magnify_tracker : ModuleMagnifyTracker = $MagnifyTracker
@onready var mover : ModuleMoverMouse = $Mover
@onready var body : ModuleBody = $Body
@onready var bite_giver : ModuleBiteGiver = $BiteGiver
@onready var clue_giver : ModuleClueGiver = $ClueGiver

var dead := false

signal died(m:Mouse)

# @NOTE: Mice have NO collision mask (only layer1 = true), so that they don't get stuck on anything and the player doesn't accidentally run into them, but other areas will still pick them up
func activate() -> void:
	visuals.activate()
	mover.activate()
	magnify_tracker.activate()
	bite_giver.activate()
	clue_giver.activate()
	body.activate()

# @TODO: worded like this because multiple things might end up having requests, so we should really mediate that instead of setting set_visible without questions
func request_visibility(val:bool) -> void:
	set_visible(val)

# @TODO: more complicated behavior of course
func kill() -> void:
	if dead: return
	
	dead = true
	died.emit()
	set_visible(true)
	
	var tw := get_tree().create_tween()
	tw.tween_property(self, "scale", 2.0*Vector2.ONE, 1.0)
	await tw.finished
	
	self.queue_free()
