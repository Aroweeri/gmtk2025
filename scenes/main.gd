extends Node2D

var Obstacle = preload("res://scenes/obstacle.tscn")

func _process(delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	#loop and create 800 different asteroids
	for i in range(800):
		
		#use tempRotator and tempPositioner to pick a random angle and go out a random distance, to 
		#distribute astreroids equally around the center.
		var tempRotator = Node2D.new()
		var tempPositioner = Node2D.new();
		tempRotator.rotation = randf()*PI*2
		tempPositioner.position = Vector2(1500 + (randf()*6000), 0);
		tempRotator.add_child(tempPositioner);
		var targetPosition = Vector2(tempPositioner.global_position);
		
		#create the asteroid from the obstacle.tscn scene
		var newObstacle = Obstacle.instantiate()
		
		#set it's position using the position calculated above
		newObstacle.position = targetPosition
		
		#use math to determine and set the scale of the new asteroid
		var myrand = randf()
		var scaleFactor = (pow(myrand, 4)*2+0.5)/3
		(newObstacle.get_node("CollisionShape2D/Sprite2D") as Node2D).scale *= scaleFactor #just sprite size
		
		#set it's size for eating math
		newObstacle.startingSize = newObstacle.get_node("CollisionShape2D").shape.radius
		newObstacle.size = newObstacle.startingSize * scaleFactor
		
		#now to scale the collision shape to match the sprite's size (can't just scale it, it breaks)
		#workaround to avoid changing one asteroid's collision shape causing all the asteroids to use that shape
		var s = newObstacle.get_node("CollisionShape2D").shape
		s = s.duplicate();
		s.radius *= scaleFactor
		(newObstacle.get_node("CollisionShape2D") as CollisionShape2D).shape = s
		
		#pick a random rotation
		newObstacle.rotation = randf()*PI*2
		
		#add to scene so it'll be actually be visible
		add_child(newObstacle)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")): #ESC for now
		get_tree().quit();
		

#draw the circle showing the player's trajectory
func _draw() -> void:
	var radius = $PlayerRotator/Player.position.x;
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 5, true)
