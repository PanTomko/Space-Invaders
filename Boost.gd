extends Area2D

export (String) var boost_name

func _ready():
	randomize()
	position.x = randi()%600

func _process(delta):
	position.y += 400 * delta
