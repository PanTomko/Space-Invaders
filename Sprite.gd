extends Sprite

var speed = 1
var center = Vector2( 300, 400)
var r = 200
var rot = 3

func _ready():
	pass

func _process(delta):
	rot += delta * speed
	
	position.x = center.x + ( cos(rot) * r)
	position.y = center.y + ( sin(rot) * r)
