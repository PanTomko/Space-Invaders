extends Node2D

func _draw():
	#draw_line(
	pass

func _ready():
	print(position.angle_to_point(get_node("../Koło").position))

func _process(delta):
	rotation = position.angle_to_point(get_node("../Koło").position)
	position = get_node("../Koło").position
