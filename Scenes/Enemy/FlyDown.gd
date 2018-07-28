extends Node

var active = true

func _ready():
	get_parent().status = get_parent().ACTIVE

func _process(delta):
	
	get_parent().position.y += 700 * delta
	
	if get_parent().position.y >= 1000:
		get_parent().queue_free()


func _on_Alien_03_on_player_coll( player ):
	if active == true:
		player.get_parent().set_live(player.get_parent().live - 1)
		active = false