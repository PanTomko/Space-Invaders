extends Area2D

export (int) var speed = 500
export (int) var damage
var vel = Vector2()

enum sides { FRIEND = 0, ENEMY = 1 }
export (sides) var side = 0

func _ready():
	pass

func _process(delta):
	position += speed * delta * vel
	
func _on_LiveTimer_timeout():
	queue_free()
	
func die():
	$Sprite.hide()
	$Light2D.hide()
	$CollisionShape2D.disabled = true
	$Particles2D.emitting = true
	vel = Vector2()

func _on_Bullet_area_entered( area ):
	if area.is_in_group("player") and side == 1:
		die()
	if area.is_in_group("enemy") and side == 0:
		die()
