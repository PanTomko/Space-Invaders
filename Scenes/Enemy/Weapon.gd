extends Node

export (PackedScene) var bullet

onready var bullet_contner_node = get_node("../../../AliensBullets")
var shooting = false
var extra_space = Vector2(50, 50)

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Shoot_timeout():
	if get_parent().status != get_parent().DED and shooting == true:
		var degree = get_parent().rotation
		var pos = get_parent().position
		
		var b1 = bullet.instance()
		
		b1.vel.x = cos(degree)
		b1.vel.y = sin(degree)
		b1.position = pos + (b1.vel * extra_space)
		bullet_contner_node.add_child(b1)
		
		var b2 = bullet.instance()
		b2.vel.x = cos(degree + deg2rad(90))
		b2.vel.y = sin(degree + deg2rad(90))
		b2.position = pos + (b2.vel * extra_space)
		bullet_contner_node.add_child(b2)
		
		var b3 = bullet.instance()
		b3.vel.x = cos(degree + deg2rad(90*2))
		b3.vel.y = sin(degree + deg2rad(90*2))
		b3.vel = b3.vel.normalized()
		b3.position = pos + (b3.vel * extra_space)
		bullet_contner_node.add_child(b3)
		
		var b4 = bullet.instance()
		b4.vel.x = cos(degree + deg2rad(90*3))
		b4.vel.y = sin(degree + deg2rad(90*3))
		b4.position = pos + (b4.vel * extra_space)
		bullet_contner_node.add_child(b4)

func _on_SalwaTime_timeout():
	shooting = false
	$SalwaWait.start()

func _on_SalwaWait_timeout():
	shooting = true
	$SalwaTime.start()
