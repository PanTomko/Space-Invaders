extends Area2D

onready var speed = 1
onready var speed_acc = 100

var arr_of_id = Array()

func _ready():
	pass

func _process(delta):
	scale.x += delta * speed
	scale.y += delta * speed
	
	speed_acc += delta*12
	speed += delta * speed_acc

func _on_Puls_area_entered( area ):
	var distance = position.distance_to(area.position)
	var r = (scale.x * 33) - 100
	
	if !arr_of_id.has(area.get_instance_id()) and distance > r :
		arr_of_id.push_back(area.get_instance_id())
		
		if area.is_in_group("bullet") and area.side == area.ENEMY:
			area.die()
		
		if area.is_in_group("enemy") and area.status != area.DED:
			area.teak_dmg(4)
			


func _on_Die_timeout():
	queue_free()
