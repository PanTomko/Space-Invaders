extends Node

export (PackedScene) var bullet
export (PackedScene) var puls

export var lvl = 0
var vel = Vector2(0, -1)

enum powers { NONE = 0, DOUBLE = 1, PULS = 2, SPEED = 3 }
var power = NONE

func _ready():
	#get_parent().get_node("Sprite/AnimationPlayer").playback_speed += 4
	pass
	
func shoot(pos):
	
	match(lvl):
		0:
			if !get_parent().get_node("Power_timers/TDouble").is_stopped():
				add_bullet(Vector2(pos.x - 20, pos.y))
				add_bullet(Vector2(pos.x + 20, pos.y))
			else:
				add_bullet(pos)
		1:
			if !get_parent().get_node("Power_timers/TDouble").is_stopped():
				
				add_bullet(Vector2(pos.x - 20, pos.y))
				add_bullet(Vector2(pos.x - 40, pos.y))
				add_bullet(Vector2(pos.x + 20, pos.y))
				add_bullet(Vector2(pos.x + 40, pos.y))
			else:
				add_bullet(Vector2(pos.x - 20, pos.y))
				add_bullet(Vector2(pos.x + 20, pos.y))
		2:
			if !get_parent().get_node("Power_timers/TDouble").is_stopped():
				add_bullet(Vector2(pos.x - 20, pos.y))
				add_bullet(Vector2(pos.x - 60, pos.y))
				add_bullet(Vector2(pos.x - 40, pos.y))
				add_bullet(Vector2(pos.x + 20, pos.y))
				add_bullet(Vector2(pos.x + 40, pos.y))
				add_bullet(Vector2(pos.x + 60, pos.y))
			else:
				add_bullet(Vector2(pos.x - 25, pos.y))
				add_bullet(pos)
				add_bullet(Vector2(pos.x + 25, pos.y))
		3:
			if !get_parent().get_node("Power_timers/TDouble").is_stopped():
				add_bullet(Vector2(pos.x - 20, pos.y))
				add_bullet(Vector2(pos.x - 60, pos.y))
				add_bullet(Vector2(pos.x - 80, pos.y))
				add_bullet(Vector2(pos.x - 100, pos.y))
				add_bullet(Vector2(pos.x - 40, pos.y))
				add_bullet(Vector2(pos.x + 20, pos.y))
				add_bullet(Vector2(pos.x + 40, pos.y))
				add_bullet(Vector2(pos.x + 60, pos.y))
				add_bullet(Vector2(pos.x + 80, pos.y))
				add_bullet(Vector2(pos.x + 100, pos.y))
			else:
				add_bullet(Vector2(pos.x - 50, pos.y))
				add_bullet(Vector2(pos.x - 25, pos.y))
				add_bullet(pos)
				add_bullet(Vector2(pos.x + 25, pos.y))
				add_bullet(Vector2(pos.x + 50, pos.y))
			
	
	
func add_bullet(pos):
	var node = get_node("../../Bullets")
	
	var a = bullet.instance()
	a.position = pos
	a.vel = vel
	node.add_child(a)

func use_power():
	var node = get_node("../../Bullets")
	
	if power == PULS:
		var a = puls.instance()
		a.position = get_parent().position
		node.add_child(a)
		
	elif power == SPEED:
		get_parent().get_node("Sprite/AnimationPlayer").playback_speed += 1
		get_parent().get_node("Power_timers/TSpeed").start()
		
	elif power == DOUBLE:
		get_parent().get_node("Power_timers/TDouble").start()
	
	power = NONE

func _on_TSpeed_timeout():
	get_parent().get_node("Sprite/AnimationPlayer").playback_speed -= 1

func _on_TDouble_timeout():
	pass
