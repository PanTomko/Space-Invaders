extends KinematicBody2D

var i = 0
var active = true

export var speed_sw = 100
var direction_sw = 1

var a
var height = 100

enum boss_states { 
	NULL = 0, 
	STAY = 1, 
	SW = 2, 
	LEFT = 3, 
	RIGHT = 4, 
	ENTER = 5, 
	SF_PRE = 6, 
	SF = 7, 
	LZ = 8 
}

export (boss_states) var boss_state



var last_state = NULL
var entred = false
var player

######## SF stats
#

var position_SF = true
var working_SF = false

export var speed_rot = 2
export var radius = 500
var rot = 0

var salva_was = 0 # Did boss shot salva ( 75% - 50% ) life
var salva_max = 4 # how many time boss can shoot salva on stage #2
var salva_done = true # is it time for next salva ?

#
########
######## LZ stats
#

var lazer_started = false
var lazer_pos = false
var lazer_was = false # Did boss shot lazers ( 40% - 0% ) life
var lazer_cout = 0
var lazer_max_count = 3

#
########

func _ready():
	
	player = get_tree().get_root().get_node("Game/Player")
	a = 100 / ( 125 * 125 )
	
func _process(delta):
	if entred == true:
		if getProcentageHealt() <= 70 and salva_done and salva_was < salva_max:
			if boss_state != SF or boss_state != SF_PRE:
				
				salva_done = false
				speed_rot = -speed_rot
				salva_was += 1
				
				set_state(SF_PRE)
				get_node("SF_time").start()
				print("lol1")
		
		if getProcentageHealt() <= 40 and !lazer_started:
			print("lol2")
			lazer_started = true
			set_state(LZ)
			$LZ_time.start()
		
		if player.position.y < 400 and boss_state <= 4:
			if player.position.x > 300 and boss_state != LEFT : set_state(LEFT)
			elif player.position.x < 300 and boss_state != RIGHT : set_state(RIGHT)
		elif boss_state <= 4 and boss_state != SW:
			set_state(SW)
		
	move_boss(delta)

func move_boss(dt):
	# LZ code
	if boss_state == LZ:
		
		var center = Vector2(300,400)
		position -= (position.distance_to(center)*2) * dt * 2 * direction_to_pos(center)
		
		if $LZ_time.time_left >= 2.2:
			main_body_rot(dt*5)
		elif $LZ_time.time_left <= 2 and !lazer_was:
			
			lazer_was = true
			lazer_cout +=1
			$Lazer.start_lazer()
		else:
			$Lazer/Particles2D.emitting = true
		
		if lazer_was:
			main_body_rot(dt*2)
			
	# SF_PRE code
	if boss_state == SF_PRE:
		if get_node("SF_time").time_left > 2.4:
			var center = player.position
			
			if rot > 6.288:
				rot -= 6.288
			rot += dt * speed_rot
			
			var new_position = Vector2()
			new_position.x = center.x + ( cos(rot) * radius )
			new_position.y = center.y + ( sin(rot) * radius )
			
			main_body_rot(dt*40)
			position -= position.distance_to(new_position) * dt * 2 * direction_to_pos(new_position)
		else:
			if get_node("SF_time").time_left > 1.6:
				get_node("../Path2D").position = position
				get_node("../Path2D").rotation = rotation
				get_node("../Path2D/SF_path").unit_offset = 0.25
				set_state(SF)
	
	# SF code
	if boss_state == SF:
		
		get_node("../Path2D/SF_path").unit_offset += dt * 2
		position = get_node("../Path2D/SF_path").global_position
	
	# ENTER code
	if boss_state == ENTER:
		if !$Animation.is_playing(): $Animation.play("Enter")
	
	# RIGHT code
	if boss_state == RIGHT:
		main_body_rot(dt*2)
		position -= 2 * Vector2(425, 200).distance_to(position) * dt * direction_to_pos(Vector2(425, 200))
	
	# LEFT code
	if boss_state == LEFT:
		main_body_rot(dt*2)
		position -= 2 * Vector2(175, 200).distance_to(position) * dt * direction_to_pos(Vector2(175, 200))
	
	# SW code
	if boss_state == SW:
		
		# movement
		position.x += dt * speed_sw * direction_sw
		#position.y = (0.0064 * (position.x - 175) * (position.x - 425) ) + 200
		
		var new_position = Vector2(position.x, (0.0064 * (position.x - 175) * (position.x - 425) ) + 200) # position 
		position.y -= (position.y - new_position.y) * dt * 10
		
		if position.x > 400: direction_sw = -1
		elif position.x < 150: direction_sw = 1
		
		main_body_rot(dt)

func getProcentageHealt():
	return (get_parent().get_node("Container/TextureProgress").value / get_parent().get_node("Container/TextureProgress").max_value)*100

func direction_to_pos(pos):
	var direction = Vector2(position.x - pos.x, position.y - pos.y).normalized()
	return direction

# Rotation of body
func main_body_rot(dt):
	
	# rotation of main body
	
	var vector = Vector2(position - player.position).normalized()
	var rad = atan2(vector.y, vector.x)
	vector = Vector2(cos(rad + deg2rad(90)), sin(rad + deg2rad(90)))
	rad = atan2(vector.y, vector.x)
	var rad_in_deg = rad2deg(rad)
	
	var current_direction = Vector2( cos(rotation), sin(rotation) )
	var lenght_dir_vecs = sqrt( pow(current_direction.x - vector.x, 2) + pow(current_direction.y - vector.y, 2) )
	var rot_speed = 75 * lenght_dir_vecs
		
	if rotation_degrees > 90 and rad_in_deg < -90:
		rotation_degrees += rot_speed * dt
		if rotation_degrees > 180:
			rotation_degrees = (rotation_degrees - 180) + (-180)
	
	elif rotation_degrees < -90 and rad_in_deg > 90:
		rotation_degrees -= rot_speed * dt
		if rotation_degrees < -180:
			rotation_degrees = (rotation_degrees + 180) + 180
		
	elif rotation_degrees > rad_in_deg:
		rotation_degrees -= rot_speed * dt
	
	elif rotation_degrees < rad_in_deg:
		rotation_degrees += rot_speed * dt
		
	#rotation_degrees = rad_in_deg

# On "enter" animation end boss activation
func _on_Animation_animation_finished(anim_name):
	match anim_name:
		"Enter": 
			if has_node("Rec_gun"): $Rec_gun.status = $Rec_gun.statuses.ACTIVE
			if has_node("Rec_gun2"): $Rec_gun2.status = $Rec_gun2.statuses.ACTIVE
			if has_node("Rot_gun"): $Rot_gun.status = $Rot_gun.statuses.ACTIVE
			entred = true
			set_state(SW)
			last_state = SW

# Eazy way to set stat for all of boss seperated parts
func set_state(new_state):
	print(new_state)
	boss_state = new_state
	if has_node("Rec_gun"): get_node("Rec_gun/Gun_rec_gun").set_mode(new_state)
	if has_node("Rec_gun2"): get_node("Rec_gun2/Gun_rec_gun").set_mode(new_state)
	if has_node("Rot_gun"): get_node("Rot_gun/Rot_gun_weapon").set_mode(new_state)

func _on_SF_time_timeout():
	set_state(NULL)
	salva_done = true
	$SF_time.stop()


func _on_LZ_time_timeout():
	$Lazer.stop_lazer()
	
	if lazer_cout <= lazer_max_count:
		lazer_was = false
	else:
		set_state(NULL)
		$LZ_time.stop()
		get_parent().spawner.spawn("Alien_04")
		get_parent().spawner.spawn("Alien_04")
