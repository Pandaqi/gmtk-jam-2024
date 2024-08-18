extends ObstacleType
class_name ObstacleFinish

func on_body_entered(o:Obstacle, body:PlayerBot) -> void:
	var num_stars_needed := body.map_data.generator.num_stars
	var num_stars_grabbed := body.player.score
	if num_stars_grabbed < num_stars_needed:
		print("You need more stars!")
		return
	
	var distance_left := body.paper_follower.get_distance_left()
	var max_dist := Global.config.scale(Global.config.max_distance_left_at_end)
	if Global.config.must_end_perfectly and distance_left > max_dist:
		print("Didn't finish perfectly!")
		return
	
	print("Player entered finish!")
	GSignal.game_over.emit(true)
