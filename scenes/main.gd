extends Node2D

var Obstacle = preload("res://scenes/obstacle.tscn")

func _process(delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	for i in range(800):
		var tempRotator = Node2D.new()
		var tempPositioner = Node2D.new();
		tempRotator.rotation = randf()*PI*2
		tempPositioner.position = Vector2(1500 + (randf()*6000), 0);
		tempRotator.add_child(tempPositioner);
		var targetPosition = Vector2(tempPositioner.global_position);
		
		var newObstacle = Obstacle.instantiate()
		newObstacle.position = targetPosition
		var myrand = randf()
		var scaleFactor = pow(myrand, 4)*2+0.5
		(newObstacle.get_node("CollisionShape2D/Sprite2D") as Node2D).scale *= scaleFactor
		var s = newObstacle.get_node("CollisionShape2D").shape
		s = s.duplicate();
		s.radius *= scaleFactor
		(newObstacle.get_node("CollisionShape2D") as CollisionShape2D).shape = s
		
		newObstacle.rotation = randf()*PI*2
		add_child(newObstacle)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		get_tree().quit();
		

func _draw() -> void:
	var radius = $PlayerRotator/Player.position.x;
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 5, true)
