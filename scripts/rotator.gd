extends Node2D

var BASE_ROTATION_SPEED=2000
var MAX_ROTATION_SPEED=0.003
var additionalRotationSpeed=0
var playerIsSnowballing=false;
var snowballCounter=0

func _physics_process(delta: float) -> void:
	
	if(playerIsSnowballing and snowballCounter < 200):
		BASE_ROTATION_SPEED+=60
		snowballCounter+=1
		
	#rotate faster/slower based on distance from center of world to player
	var distance_to_player = self.global_position.distance_to($Player.global_position)
	
	var rotate_amount = BASE_ROTATION_SPEED/2.0 * (1.0/distance_to_player) * delta
	
	#if(Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up")):
		#rotate_amount /= 2
		
	#print("Distance: %0.2f Degrees/Sec: %0.2f" % [distance_to_player, rad_to_deg(rotate_amount)/delta])
	var isBoostingOrSlowing = false;
	if(Input.is_action_pressed("boost")):
			additionalRotationSpeed += 0.01 * delta * 10000/distance_to_player
			isBoostingOrSlowing = true
	if(Input.is_action_pressed("slow")):
			additionalRotationSpeed -= 0.01 * delta * 3000/distance_to_player
			isBoostingOrSlowing = true
	if(additionalRotationSpeed > 0.005):
		additionalRotationSpeed = 0.005
	if(additionalRotationSpeed < -0.0020):
		additionalRotationSpeed = -0.0020
	additionalRotationSpeed *= 0.95
	
	if(not isBoostingOrSlowing and abs(additionalRotationSpeed) < 0.0001):
		additionalRotationSpeed = 0;
	
	#print(additionalRotationSpeed)
			
	rotate(rotate_amount + additionalRotationSpeed);
		
func _on_player_is_snowballing() -> void:
	playerIsSnowballing=true;
	var tween = get_tree().create_tween()
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.05, 0.05), 4);
	
