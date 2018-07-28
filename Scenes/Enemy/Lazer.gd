extends Area2D

var is_lazer = false
var lazer_length = 1000
export var lazer_speed = float()

func start_lazer():
	
	$LazerSprite.visible = true
	$LazerSprite.region_rect.size.y = lazer_length
	$LazerSprite.position.y = lazer_length / 2
	
	$CollisionShape2D.disabled = false
	$CollisionShape2D.shape.extents.y = lazer_length / 2
	$CollisionShape2D.position.y = lazer_length / 2
	
	$Light2D.enabled = true
	$LazerStartSprite.visible = true
	$Sound.play()
	
	
	is_lazer = true

func stop_lazer():
	
#	$Sound.stop()
	$Light2D.enabled = false
	$Particles2D.emitting = false
	$LazerSprite.visible = false
	$CollisionShape2D.disabled = true
	$LazerStartSprite.visible = false
	is_lazer = false

func _ready():
	pass

func _process(delta):
	if is_lazer:
		$LazerSprite.region_rect.position.y -= delta * lazer_speed
