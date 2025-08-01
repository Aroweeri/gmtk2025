extends RigidBody2D
	
func _physics_process(delta: float) -> void:
	apply_torque(1000*delta);
