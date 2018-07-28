extends Node

export (int) var gun_rotation_speed

var player

export (PackedScene) var bullet
onready var bullet_contner_node = get_tree().get_root().get_node("Game/Spawner/AliensBullets")
var bullet_speed = 500

var mode = 0

func _ready():
	player = get_tree().get_root().get_node("Game/Player")
	

func set_mode(what_mode):
	mode = what_mode
	
	if mode == 2:
		$Shoot_time.wait_time = 2
		bullet_speed = 400
	
	if mode == 3 or mode == 4 or mode == 8:
		bullet_speed = 600
		$Shoot_time.wait_time = 0.2

func _on_Shoot_time_1_timeout():
	if get_parent().status == get_parent().ACTIVE and mode == 3 or mode == 4 or mode == 2:
		var bullet0 = bullet.instance()
		var rot = get_parent().get_node("Sprite").rotation + get_parent().get_parent().rotation
		bullet0.vel = Vector2( cos(rot + deg2rad(90)), sin(rot + deg2rad(90)) )
		bullet0.position = get_parent().global_position + (bullet0.vel * 40)
		bullet0.speed = bullet_speed
		
		bullet_contner_node.add_child(bullet0)


func _process(delta):
	# vector fids
	var vector = Vector2(get_parent().get_parent().position - player.position).normalized()
	var rad = atan2(vector.y, vector.x)
	vector = Vector2(cos(rad + deg2rad(90)), sin(rad + deg2rad(90)))
	rad = atan2(vector.y, vector.x)
	var rad_in_deg = rad2deg(rad) - get_parent().get_parent().rotation_degrees
	
	var current_direction = Vector2(cos(get_parent().get_node("Sprite").rotation), sin(get_parent().get_node("Sprite").rotation))
	
	var lenght_dir_vecs = current_direction.distance_to(vector)
	#sqrt( pow(current_direction.x - vector.x, 2) + pow(current_direction.y - vector.y, 2) )
	
	var speed_rot = gun_rotation_speed * delta
	
	if get_parent().get_node("Sprite").rotation_degrees > 90 and rad_in_deg < -90:
		get_parent().get_node("Sprite").rotation_degrees += speed_rot
		if get_parent().get_node("Sprite").rotation_degrees > 180:
			get_parent().get_node("Sprite").rotation_degrees = (get_parent().get_node("Sprite").rotation_degrees - 180) + (-180)
	
	elif get_parent().get_node("Sprite").rotation_degrees < -90 and rad_in_deg > 90:
		get_parent().get_node("Sprite").rotation_degrees -= speed_rot
		if get_parent().get_node("Sprite").rotation_degrees < -180:
			get_parent().get_node("Sprite").rotation_degrees = (get_parent().get_node("Sprite").rotation_degrees + 180) + 180
	
	elif get_parent().get_node("Sprite").rotation_degrees > rad_in_deg:
		get_parent().get_node("Sprite").rotation_degrees -= speed_rot
	
	elif get_parent().get_node("Sprite").rotation_degrees < rad_in_deg:
		get_parent().get_node("Sprite").rotation_degrees += speed_rot
