extends Node2D

signal healthLost
signal playerDied

var size=0
var startingSize=0
var health=5

#size is equivalent to diameter
func size_to_mass(s):
	return PI*s*s
	
func mass_to_size(mass):
	return sqrt(mass/PI)

func _area_on_body_entered(body):
	if(body.size <= size/2.0):
		print("My Mass %f + Their Mass %f = %f" % [size_to_mass(size), size_to_mass(body.size), (size_to_mass(size)+ size_to_mass(body.size))])
		#absorb
		var bodyMass = size_to_mass(body.size)
		var myMass = size_to_mass(size)
		size = mass_to_size(bodyMass/4+myMass)
		$Sprite.scale = Vector2(size/startingSize,size/startingSize)
		$StaticBody2D/CollisionShape2D.shape.radius = startingSize*(size/startingSize)
		body.queue_free()
	else:
		health-=1
		if(health==0):
			playerDied.emit()
		else:
			healthLost.emit()

func _ready() -> void:
	startingSize = $StaticBody2D/CollisionShape2D.shape.radius
	size = startingSize
	$StaticBody2D.body_entered.connect(_area_on_body_entered);

func _physics_process(_delta: float) -> void:
	
	#player is just on an extending arm essentially.
	#Just extend/retract the arm to change their distance from center
	if(Input.is_action_pressed("ui_up")):
		translate(Vector2(10,0));
	elif(Input.is_action_pressed("ui_down")):
		translate(Vector2(-10,0));
