extends Node

func _ready():
	for i in range(100):
		randomize()
		print( randi()%3 + 1 )

func _process(delta):
	pass