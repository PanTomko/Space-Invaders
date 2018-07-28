extends KinematicBody2D

signal player_ded
signal player_get_hit(red)
signal power_has_change(name_of_boost)

var god_mode = false

var vel = Vector2()
export var live = 3
var speed = 550

enum statuses { UNACTIVE = 0, ACTIVE = 1, GET_DAMAGE = 2 }
var status = UNACTIVE

func _ready():
	set_process(false)
	$Sprite/AnimationPlayer.play("Stop")
	$AudioStreamPlayer.play()

func _process(delta):
	
	if Input.is_action_just_pressed("Super"):
		$Wepon.use_power()
		emit_signal("power_has_change", "null")
	
	vel = Vector2()
	
#	Input.action_press("ui_up")
	
	if Input.is_action_pressed("ui_up"):
		vel.y = -1
		
	if Input.is_action_pressed("ui_down"):
		vel.y = 1
		
	if Input.is_action_pressed("ui_left"):
		vel.x = -1
	elif Input.is_action_pressed("ui_right"):
		vel.x = 1
		
	if Input.is_action_pressed("Shoot") and $Sprite/AnimationPlayer.current_animation != "Shoot":
		$Wepon.shoot(position)
		$Sprite/AnimationPlayer.play("Shoot")
		$LaserAudio2D.play()
	
	if !$Sprite/AnimationPlayer.is_playing():
		$Sprite/AnimationPlayer.play("Stop")

	vel = vel.normalized()

	position += vel * speed * delta
	
	position.x = clamp( position.x, 0, 600)
	position.y = clamp( position.y, 0, 800)

func _on_Game_game_start():
	set_process(true)
	status = ACTIVE

func set_live(new_live):

		if new_live > 0:
			if new_live < live and god_mode == false:
				live = new_live
				emit_signal("player_get_hit", true)
				$God_mode_timer.start()
				$TookDamage.play()
				$Animation.play("god_mode")
				god_mode = true
				
				
			elif new_live > live:
				live = new_live
				emit_signal("player_get_hit", false)
				if new_live > 10: new_live = 10
				
			
		elif status == ACTIVE:
			$TookDamage.play()
			emit_signal("player_get_hit")
			emit_signal("player_ded")
			set_process(false)
			status = UNACTIVE
			
			$Animation.get_animation("god_mode").loop = true
			$Animation.play("god_mode")
			
			$Bombs.emitting = true
			$BombsAudio.play()

func _on_Area2D_area_entered( area ):
	if area.is_in_group("Boost"):
		
		match(area.boost_name):
			"speed"  : $Wepon.power = $Wepon.SPEED
			"puls"   : $Wepon.power = $Wepon.PULS
			"double" : $Wepon.power = $Wepon.DOUBLE
		
		emit_signal("power_has_change", area.boost_name)
		
		area.queue_free()
	
	if area.is_in_group("bullet") and area.side == 1:
		set_live(live - area.damage)
	
	if area.is_in_group("lazer"):
		set_live(live - 1)
	
	if area.is_in_group("lvlUP"):
		area.queue_free()
		if $Wepon.lvl < 3: 
			$Wepon.lvl += 1
			get_node("Sprite/AnimationPlayer").playback_speed = get_node("Sprite/AnimationPlayer").playback_speed + 0.2
	
	if area.is_in_group("HP"):
		set_live(live + 1)
		area.queue_free()

func _on_God_mode_timer_timeout():
	god_mode = false
	$Animation.play("X")
	$Animation.stop()