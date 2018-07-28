extends Node

onready var rot = get_parent().rotation_degrees
var rot_speed = 60

func _ready():
	get_parent().rotation_degrees = 45
	pass

func _process(delta):
	
	get_parent().rotation_degrees += rot_speed * delta
	if get_parent().rotation_degrees >= 360:
		get_parent().rotation_degrees = get_parent().rotation_degrees - 360