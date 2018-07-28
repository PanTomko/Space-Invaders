extends Node

export (PackedScene) var bullet

onready var bullet_contner_node = get_node("../../../AliensBullets")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_ShootTime_timeout():
	if get_parent().status != get_parent().DED:
		var bullet0 = bullet.instance()
		bullet0.vel.y = 1
		bullet0.position = get_parent().position + (bullet0.vel * 40)
		
		bullet_contner_node.add_child(bullet0)
