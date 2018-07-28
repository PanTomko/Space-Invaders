extends TextureProgress

signal rip_boss

func _ready():
	var boss_body = get_parent().get_parent().get_node("Boss_body")
	max_value = boss_body.get_node("Rec_gun").max_live + boss_body.get_node("Rec_gun2").max_live + boss_body.get_node("Rot_gun").max_live
	get_parent().get_parent().get_node("Boss_body/Animation").get_animation("Enter").track_set_key_value(1,1, max_value)
	#value = max_value
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Rot_gun_dmg_taken(dmg):
	value -= dmg;
	if value <= 0: emit_signal("rip_boss")
