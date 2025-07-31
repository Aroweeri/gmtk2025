extends Node2D

var ROTATION_SPEED=500

func _process(_delta):
	pass;
	
func _physics_process(delta: float) -> void:
	var distance_to_player = self.global_position.distance_to($Player.global_position)
	var rotate_amount = ROTATION_SPEED * (1/distance_to_player) * delta
	#print("Distance: %0.2f Degrees/Sec: %0.2f" % [distance_to_player, rad_to_deg(rotate_amount)/delta])
	rotate(rotate_amount)
