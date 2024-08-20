class_name LineFollower

var line : Line
var cur_index : int
var cur_point : Vector2
var traveling := false
var points_absolute : Array[Vector2]

var time_traveled := 0.0
var target_travel_time := 0.0
var travel_dir := 1

func _init(l:Line, map_data:MapData, dir := 1, must_convert := true) -> void:
	line = l
	travel_dir = dir
	
	points_absolute = []
	for point in line.points:
		if not must_convert: points_absolute.append(point)
		else: points_absolute.append(map_data.convert_line_pos_to_absolute_pos(point))
	
	traveling = false

func start_travel() -> void:
	traveling = true
	
	if travel_dir > 0:
		cur_index = 0
		cur_point = points_absolute.front()
	else:
		cur_index = points_absolute.size() - 1
		cur_point = points_absolute.back()

# this is called at first, then the type decides how the pencil should be followed
# in most cases though, they just use advance_default below
func advance(pf:ModulePaperFollower, speed:float) -> Vector2:
	var vec := line.type.update(self, pf, speed)
	var has_mask := line.type.follow_mask.length() > 0.003
	var dot_prod := vec.normalized().dot(line.type.follow_mask.normalized())
	if has_mask and dot_prod <= 0: return Vector2.ZERO
	vec *= line.type.vec_scale_factor
	return vec

func advance_default(speed:float) -> Vector2:
	time_traveled += speed
	
	var move_vec := Vector2.ZERO
	var cur_anchor := cur_point
	
	# while we have more to go, and the line hasn't ended yet
	while speed > 0 and not travel_is_done():
		var new_vec := points_absolute[cur_index + 1*travel_dir] - cur_anchor
		var dist := new_vec.length()
		
		# if we can fully make the next leap, do it
		# also update index and anchor (first point BEHIND us) to match
		if dist < speed:
			cur_index += travel_dir
			move_vec += new_vec
			cur_anchor = points_absolute[cur_index]
			speed -= dist
			continue
		
		# otherwise, do what we can and stop
		move_vec += speed * new_vec.normalized()
		speed = 0.0
	
	cur_point += move_vec
	return move_vec

func travel_has_started() -> bool:
	return traveling

func travel_is_done() -> bool:
	if not traveling: return true
	if travel_dir > 0 and cur_index >= (count() - 1): return true
	if travel_dir < 0 and cur_index <= 0: return true
	return false

func get_ratio_traveled() -> float:
	if target_travel_time <= 0.0: return 0.0
	return clamp(time_traveled / target_travel_time, 0.0, 1.0)

func get_travel_distance_left() -> float:
	return (1.0 - get_ratio_traveled()) * get_length_absolute()

func count() -> int:
	return line.count()

func on_start(pf:ModulePaperFollower) -> void:
	traveling = true
	line.type.on_start(self, pf)

func on_end(pf:ModulePaperFollower) -> void:
	traveling = false
	line.type.on_end(self, pf)

func get_length_absolute() -> float:
	var sum := 0.0
	for i in range(points_absolute.size() - 1):
		sum += points_absolute[i+1].distance_to(points_absolute[i])
	return sum
