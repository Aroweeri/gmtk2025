extends Node2D

var ROTATION_SPEED=2000

func _physics_process(delta: float) -> void:
	
	#rotate faster/slower based on distance from center of world to player
	var distance_to_player = self.global_position.distance_to($Player.global_position)
	
	var rotate_amount = ROTATION_SPEED/2 * (1/distance_to_player) * delta
	if(Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up")):
		rotate_amount /= 2
		
	
	#print("Distance: %0.2f Degrees/Sec: %0.2f" % [distance_to_player, rad_to_deg(rotate_amount)/delta])
	if(Input.is_action_pressed("boost")):
		rotate(rotate_amount*3)
	else:
		rotate(rotate_amount);
