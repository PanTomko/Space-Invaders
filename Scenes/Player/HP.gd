extends Area2D

export (int) var speed

func _ready():
	position.y = -200
	randomize()
	position.x = rand_range(50, 550)

func _process(delta):
	position.y += speed * delta
	
	if position.y > 1000:
		queue_free()
