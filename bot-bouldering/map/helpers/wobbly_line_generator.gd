class_name WobblyLineGenerator

var points : Array[Vector2]
var noise : Noise

var start : Vector2
var end : Vector2
var displacement_scale_factor : float = 1.0

func _init() -> void:
	points = []
	noise = FastNoiseLite.new()

func generate(start_pos:Vector2, end_pos:Vector2) -> void:
	start = start_pos
	end = end_pos
	
	var dir := (end_pos - start_pos).normalized()
	var increment := Global.config.scale(Global.config.mountain_noise_increments)
	var displacement_scale := Global.config.scale(Global.config.mountain_noise_displacement) * displacement_scale_factor
	var noise_scale := Global.config.mountain_noise_scale
	
	points = [start_pos]
	var raw_point := start_pos
	var counter := 0
	while raw_point.distance_to(end_pos) > increment:
		var new_pos := start_pos + counter*dir*increment
		raw_point = new_pos
		
		var displacement := 2 * (noise.get_noise_1d(new_pos.dot(dir) * noise_scale) + 0.5) * displacement_scale
		new_pos += displacement * dir.rotated(-0.5*PI)
		points.append(new_pos)
		counter += 1
	points.append(end_pos)

func regenerate(disp_scale := 1.0) -> void:
	displacement_scale_factor = disp_scale
	generate(start, end)

func scale(val:float) -> void:
	for i in range(points.size()):
		points[i] *= val
