extends Node

export (int) var speed = 200

var enemy
var vel = 0

func _ready():
	pass

func _process(delta):
	if enemy.status == 1:
		enemy.position.x += delta * speed * vel
	
	#enemy.position.x = clamp(enemy.position.x, 0, 600)


func _on_Timer_timeout():
	vel = round(rand_range(-1, 1))
