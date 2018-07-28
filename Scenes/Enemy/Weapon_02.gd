extends Node

export (PackedScene) var bullet

onready var bullet_contner_node = get_node("../../../AliensBullets")

func _ready():
	pass

func _on_ShootTime_timeout():
	if get_parent().status != get_parent().DED:
		var bullet0 = bullet.instance()
		bullet0.vel.y = 1
		bullet0.position = get_parent().position + (bullet0.vel * 40)
		bullet_contner_node.add_child(bullet0)
		
		var bullet1 = bullet.instance()
		bullet1.vel.y = 0.9
		bullet1.vel.x = 0.1
		bullet1.position = get_parent().position + (bullet1.vel * 40)
		bullet_contner_node.add_child(bullet1)
		
		var bullet2 = bullet.instance()
		bullet2.vel.y = 0.9
		bullet2.vel.x = -0.1
		bullet2.position = get_parent().position + (bullet2.vel * 40)
		bullet_contner_node.add_child(bullet2)
