extends Node2D

signal healthLost
signal playerDied
signal ateAsteroid
signal isSnowballing

var MINIMUM_HEIGHT = 8000
var MAXIMUM_HEIGHT = 23000
var size=0
var startingSize=0
var health=4
var speed=0
var massInLevel

#size is equivalent to diameter
func size_to_mass(s):
	return PI*s*s
	
func mass_to_size(mass):
	return sqrt(mass/PI)

func _area_on_body_entered(body):
	if(body.size <= size/1.5):
		#print("My Mass %f + Their Mass %f = %f" % [size_to_mass(size), size_to_mass(body.size), (size_to_mass(size)+ size_to_mass(body.size))])
		#absorb
		var bodyMass = size_to_mass(body.size)
		var myMass = size_to_mass(size)
		if(myMass > massInLevel/2*0.12):
			#print("snowballing")
			isSnowballing.emit()
		size = mass_to_size(bodyMass/3+myMass)
		$Sprite.scale = Vector2(size/startingSize,size/startingSize)
		$StaticBody2D/CollisionShape2D.shape.radius = startingSize*(size/startingSize)
		#$Camera2D.zoom 
		body.queue_free()
		ateAsteroid.emit()
	else:
		health-=1
		if(health<0):
			playerDied.emit()
		else:
			healthLost.emit()

func _ready() -> void:
	startingSize = $StaticBody2D/CollisionShape2D.shape.radius
	size = startingSize
	$StaticBody2D.body_entered.connect(_area_on_body_entered);

func _physics_process(delta: float) -> void:
	
	#player is just on an extending arm essentially.
	#Just extend/retract the arm to change their distance from center
	if(Input.is_action_pressed("ui_up")):
		speed += 100 * delta
	elif(Input.is_action_pressed("ui_down")):
		speed -= 100 * delta;
		
	#dampen
	speed *= 0.95
		
	translate(Vector2(speed,0));
	print(position.x)
	if(position.x < MINIMUM_HEIGHT):
		position.x = MINIMUM_HEIGHT
		speed = 0
	if(position.x > MAXIMUM_HEIGHT):
		position.x = MAXIMUM_HEIGHT
		speed = 0
