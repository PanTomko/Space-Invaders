extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var alien = ResourceLoader.load("res://Scenes/Enemy/Alien_02.tscn").instance()
	alien.position.x = 0
	add_child(alien)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
