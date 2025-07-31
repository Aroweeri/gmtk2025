extends Node2D

var ROTATION_SPEED=1

func _process(_delta):
	pass;
	
func _physics_process(delta: float) -> void:
	rotate(ROTATION_SPEED * delta)
