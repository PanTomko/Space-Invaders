extends Area2D

signal on_player_coll(player)
signal on_death()
signal dmg_taken(dmg)

enum statuses { UNACTIVE = 0, ACTIVE = 1, DED = 2 }

export var tell_if_dmg_taken = false
export var positioning = true
export var if_shake = false

var spawner
var status = UNACTIVE
var rad_y

export (int) var max_live
var current_live

func _ready():
	current_live = max_live
	randomize()
	rad_y = randi()%150+50
	
	if has_node("Alien_standard_IS"):
		get_node("Alien_standard_IS").enemy = self

func _process(delta):
	if positioning: position.x = clamp(position.x, 0, 600)
	
	if positioning:
		if status == UNACTIVE:
			position.y += 250 * delta
			if position.y >= rad_y:
				position.y = rad_y
				status = ACTIVE


func teak_dmg(damage):
	current_live -= damage
	emit_signal("dmg_taken", damage)
	
	if current_live <= 0:
		death()

func death():
	status = DED
	$Sprite.hide()
	set_process(false)
	$Clear_Timer.start()
	$CollisionShape2D.disabled = true
	$DeathSound.play()
	emit_signal("on_death")
	if if_shake:
		$Shake.shake()
	

func _on_Enemy_area_entered( area ):
	if area.is_in_group("player"):
		emit_signal("on_player_coll", area)
	
	
	if area.is_in_group("bullet") and area.side == area.FRIEND:
		if status != UNACTIVE : teak_dmg(area.damage)
		
		area.damage = 0
		area.speed = 0

func _on_Clear_Timer_timeout():
	$DeathSound.stop()
	queue_free()

