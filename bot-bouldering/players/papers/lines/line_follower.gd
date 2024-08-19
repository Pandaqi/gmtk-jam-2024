class_name LineFollower

var line : Line
var cur_index : int
var cur_point : Vector2
var traveling := false
var points_absolute : Array[Vector2]

var time_traveled := 0.0
var target_travel_time := 0.0

func _init(l:Line, map_data:MapData) -> void:
	line = l
	
	points_absolute = []
	for point in line.points:
		points_absolute.append(map_data.convert_line_pos_to_absolute_pos(point))
	
	cur_index = 0
	cur_point = points_absolute.front()
	traveling = false

# this is called at first, then the type decides how the pencil should be followed
# in most cases though, they just use advance_default below
func advance(pf:ModulePaperFollower, speed:float) -> Vector2:
	return line.type.update(self, pf, speed)

func advance_default(speed:float) -> Vector2:
	var move_vec := Vector2.ZERO
	var cur_anchor := cur_point
	
	# while we have more to go, and the line hasn't ended yet
	while speed > 0 and not travel_is_done():
		var new_vec := points_absolute[cur_index+1] - cur_anchor
		var dist := new_vec.length()
		
		# if we can fully make the next leap, do it
		# also update index and anchor (first point BEHIND us) to match
		if dist < speed:
			cur_index += 1
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
	return cur_index >= (count() - 1) or (not traveling)

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
