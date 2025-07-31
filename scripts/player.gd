extends Node2D

func _process(delta: float) -> void:
	$Sprite.global_rotation = 0
	
func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed("ui_up")):
		translate(Vector2(10,0));
	elif(Input.is_action_pressed("ui_down")):
		translate(Vector2(-10,0));
