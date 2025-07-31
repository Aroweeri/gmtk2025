extends Node2D

var Obstacle = preload("res://scenes/obstacle.tscn")

func _init() -> void:
	for i in range(50):
		var tempRotator = Node2D.new()
		var tempPositioner = Node2D.new();
		tempRotator.rotation = randf()*PI*2
		tempPositioner.position = Vector2(1500 + (randf()*2000), 0);
		tempRotator.add_child(tempPositioner);
		var targetPosition = Vector2(tempPositioner.global_position);
		
		var newObstacle = Obstacle.instantiate()
		newObstacle.position = targetPosition
		(newObstacle.get_node("CollisionShape2D/Sprite2D") as Node2D).scale *= 0.5+randf()*5
		
		newObstacle.rotation = randf()*PI*2
		add_child(newObstacle)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		get_tree().quit();
