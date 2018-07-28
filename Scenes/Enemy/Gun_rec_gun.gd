extends Node

export (PackedScene) var bullet
onready var bullet_contner_node = get_tree().get_root().get_node("Game/Spawner/AliensBullets")

var mode = 0
var bullet_speed = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	pass

func set_mode(what_mode):
	mode = what_mode
	
	if mode == 2:
		$Shoot_time_1.wait_time = 0.8
		bullet_speed = 550
	elif mode == 7:
		$Shoot_time_1.wait_time = 0.1
		bullet_speed = 900
		

func _on_Shoot_time_1_timeout():
	
	if get_parent().status == get_parent().ACTIVE and mode == 7 or mode == 2:
		get_parent().get_node("Shoot_audio").play() # play sound while shooting 
		var bullet0 = bullet.instance() # get instance of bullet form bullet pack
		bullet0.speed = bullet_speed # set speed of bullet
		var rot = get_parent().get_parent().rotation # get rotation of boss body
		bullet0.vel = Vector2( cos(rot + deg2rad(90)), sin(rot + deg2rad(90)) ) # find direction form rotation
		bullet0.position = get_parent().global_position + (bullet0.vel * 40) # set position for bulet in relative to boss body
		
		bullet_contner_node.add_child(bullet0) # put bullet in place for bullets

