extends Node2D

var Obstacle = preload("res://scenes/obstacle.tscn")
var Obstacle2 = preload("res://scenes/obstacle2.tscn")
var SFXPlayer;
var TotaltoWin

func size_to_mass(s):
	return PI*s*s

func mass_to_size(mass):
	return sqrt(mass/PI)

func _process(_delta: float) -> void:
	queue_redraw()

func _ready() -> void:
	
	SFXPlayer = AudioStreamPlayer.new();
	TotaltoWin = 0
	#loop and create 800 different asteroids
	for i in range(1000):
		
		
		#use tempRotator and tempPositioner to pick a random angle and go out a random distance, to 
		#distribute astreroids equally around the center.
		var tempRotator = Node2D.new()
		var tempPositioner = Node2D.new();
		tempRotator.rotation = randf()*PI*2
		tempPositioner.position = Vector2(10000 + (sqrt(randf()*6000)*150), 0);
		tempRotator.add_child(tempPositioner);
		var targetPosition = Vector2(tempPositioner.global_position);
		
		#create the asteroid from the obstacle.tscn scene
		var newObstacle = Obstacle.instantiate()
		
		#set it's position using the position calculated above
		newObstacle.position = targetPosition
		
		#use math to determine and set the scale of the new asteroid
		var myrand = randf()
		var scaleFactor = (pow(myrand, 5)*10+0.3)/3
		(newObstacle.get_node("CollisionShape2D/Sprite2D") as Node2D).scale *= scaleFactor #just sprite size
		
		#set it's size for eating math
		newObstacle.startingSize = newObstacle.get_node("CollisionShape2D").shape.radius
		newObstacle.size = newObstacle.startingSize * scaleFactor
		TotaltoWin += size_to_mass(newObstacle.size) 
		
		#now to scale the collision shape to match the sprite's size (can't just scale it, it breaks)
		#workaround to avoid changing one asteroid's collision shape causing all the asteroids to use that shape
		var s = newObstacle.get_node("CollisionShape2D").shape
		s = s.duplicate();
		s.radius *= scaleFactor
		(newObstacle.get_node("CollisionShape2D") as CollisionShape2D).shape = s
		
		#pick a random rotation
		newObstacle.rotation = randf()*PI*2
		
		#pick a random color
		var crand = randf()
		var random_white = randf_range(0.4, 0.9)
		if crand <= 0.8:
			var random_color = Color(randf_range(0.5, 0.75), randf_range(0.2, 0.4), 0)
			(newObstacle as Node2D).modulate = random_color
		else:
			var random_color = Color(random_white, random_white, random_white)
			(newObstacle as Node2D).modulate = random_color
		
		#add to scene so it'll be actually be visible
		add_child(newObstacle)
	
	$PlayerRotator/Player.massInLevel = TotaltoWin
	#Layer 2
	#for i in range(1000):
#
		##use tempRotator and tempPositioner to pick a random angle and go out a random distance, to
		##distribute astreroids equally around the center.
		#var tempRotator = Node2D.new()
		#var tempPositioner = Node2D.new();
		#tempRotator.rotation = randf()*PI*2
		#tempPositioner.position = Vector2(10000 + (sqrt(randf()*6000)*100), 0);
		#tempRotator.add_child(tempPositioner);
		#var targetPosition = Vector2(tempPositioner.global_position);
#
		##create the asteroid from the obstacle.tscn scene
		#var newObstacle2 = Obstacle2.instantiate()
#
		##set it's position using the position calculated above
		#newObstacle2.position = targetPosition
#
		##use math to determine and set the scale of the new asteroid
		#var myrand = randf()
		#var scaleFactor = (pow(myrand, 5)*10+0.3)/3
		#(newObstacle2.get_node("CollisionShape2D/Sprite2D") as Node2D).scale *= scaleFactor #just sprite size
#
		##set it's size for eating math
		#newObstacle2.startingSize = newObstacle2.get_node("CollisionShape2D").shape.radius
		#newObstacle2.size = newObstacle2.startingSize * scaleFactor
#
		##now to scale the collision shape to match the sprite's size (can't just scale it, it breaks)
		##workaround to avoid changing one asteroid's collision shape causing all the asteroids to use that shape
		#var s = newObstacle2.get_node("CollisionShape2D").shape
		#s = s.duplicate();
		#s.radius *= scaleFactor
		#(newObstacle2.get_node("CollisionShape2D") as CollisionShape2D).shape = s
#
		##pick a random rotation
		#newObstacle2.rotation = randf()*PI*2
#
		#(newObstacle2 as Node2D).modulate = Color(0, 0, 1)
#
		##add to scene so it'll be actually be visible
		#add_child(newObstacle2)

func _on_player_health_lost():
	$CanvasLayer/MarginContainer/healthHBox.get_child($CanvasLayer/MarginContainer/healthHBox.get_children().size()-1).queue_free()
	$DamageSFX.play();

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")): #ESC for now
		get_tree().quit();
		

#draw the circle showing the player's trajectory
func _draw() -> void:
	var radius = $PlayerRotator/Player.position.x;
	draw_circle(Vector2.ZERO, radius, Color.WHITE, false, 5, true)


func _on_player_player_died() -> void:
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
	$DamageSFX.play()


func _on_player_ate_asteroid() -> void:
	$CollectSFX.play();
	var PlayerMass = size_to_mass($PlayerRotator/Player.size)
	if(PlayerMass >= TotaltoWin*0.9/2):
		get_tree().change_scene_to_file("res://scenes/Win.tscn")
	#print("%.0f out of %.0f" % [PlayerMass, TotaltoWin*0.9/2])
	
