extends RigidBody2D

func _ready():
	
	pass

func _process(delta):
	position.y -= 100 * delta
