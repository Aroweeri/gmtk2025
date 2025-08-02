extends Node2D

var ROTATION_SPEED=750
	
func _physics_process(delta: float) -> void:
	
	#rotate faster/slower based on distance from center of world to player
	var distance_to_player = self.global_position.distance_to($Player.global_position)
	var rotate_amount = ROTATION_SPEED * (1/distance_to_player) * delta
	
	#print("Distance: %0.2f Degrees/Sec: %0.2f" % [distance_to_player, rad_to_deg(rotate_amount)/delta])
	if(Input.is_action_pressed("zoom1")):
		rotate(rotate_amount*10)
	if(Input.is_action_pressed("zoom2")):
		rotate(rotate_amount*100)
	if(Input.is_action_pressed("zoom3")):
		rotate(rotate_amount*1000)
	else:
		rotate(rotate_amount);
