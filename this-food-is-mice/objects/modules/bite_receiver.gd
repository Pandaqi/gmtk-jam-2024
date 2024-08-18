class_name ModuleBiteReceiver extends Node2D

@export var visuals : ModuleVisualsObstacle
@onready var entity = get_parent()

var bite_centers : Array[Vector2] = []
var bite_sizes : Array[Vector2] = []

signal bitten(num_bites:int)
signal healed()

func activate() -> void:
	pass

func count() -> int:
	return bite_centers.size()

func heal() -> void:
	bite_centers = []
	bite_sizes = []
	healed.emit()

func take_bite(m:ModuleBiteGiver) -> void:
	print("TAKE BITE")
	
	var vec := (m.global_position - visuals.get_center()).normalized()
	
	var size := visuals.get_size()
	var pos_edge := vec*1000
	pos_edge.x = clamp(pos_edge.x, -0.5*size.x, 0.5*size.x)
	pos_edge.y = clamp(pos_edge.y, -0.5*size.y, 0.5*size.y)
	pos_edge += 0.5*size # UV space wants it 0->1 on both axes
	
	var size_bounds := Global.config.scale_bounds(Global.config.mouse_bite_size_bounds)
	var rand_size := size_bounds.interpolate(m.entity.body.get_lives_ratio())
	var rand_rot := vec.angle() + 0.5*PI
	
	bite_centers.append(pos_edge)
	bite_sizes.append(Vector2(rand_size, rand_rot))
	
	on_bite_added()

func on_bite_added() -> void:
	bitten.emit(count())
	check_if_should_die()

func check_if_should_die() -> void:
	if count() < Global.config.obstacle_num_bites_remove: return
	entity.kill()
