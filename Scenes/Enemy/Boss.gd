extends Node

var player
var spawner

func _ready():
	$Boss_body/Rot_gun.spawner = spawner
	$Boss_body/Rec_gun.spawner = spawner
	$Boss_body/Rec_gun2.spawner = spawner
	player = get_tree().get_root().get_node("Game/Player")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_TextureProgress_rip_boss():
	queue_free()


func _on_Rot_gun_dmg_taken( dmg ):
	pass # replace with function body
