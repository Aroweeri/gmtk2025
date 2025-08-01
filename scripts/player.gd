extends Node2D

func _physics_process(delta: float) -> void:
	
	#player is just on an extending arm essentially.
	#Just extend/retract the arm to change their distance from center
	if(Input.is_action_pressed("ui_up")):
		translate(Vector2(10,0));
	elif(Input.is_action_pressed("ui_down")):
		translate(Vector2(-10,0));
