extends CanvasLayer

onready var player = get_parent().get_node("Player")

var Tnull = preload("res://Graphic/Puls/null.png")
var Tspeed = preload("res://Graphic/Puls/Zegar.png")
var Tdouble = preload("res://Graphic/Puls/double.png")
var Tpuls = preload("res://Graphic/Puls/Pole.png")

func _ready():
	$Container/PopUp.hide()
	$ColorRect.hide()
	$CenterLive/Container/LiveBar.value = player.live
	
func update_pop_text(text):
	$Container/PopUp.text = text

func set_pop(text, timer = 0):
	$Container/PopUp.show()
	$Container/PopUp.text = text
	
	if timer > 0 :
		$Container/PopUp/Timer.wait_time = timer
		$Container/PopUp/Timer.start()

func _on_Timer_timeout():
	$Container/PopUp.hide()

func hide_pop():
	$Container/PopUp/Timer.stop()
	$Container/PopUp.hide()

func _on_Player_player_get_hit(red):
	$CenterLive/Container/LiveBar.value = player.live
	
	if player.god_mode == false and red == true:
		$ColorRect.show()
		$GUI_animation.play("ShowRed")



func _on_GUI_animation_animation_finished( anim_name ):
	if anim_name == "ShowRed":
		$ColorRect.hide()


func _on_Player_player_ded():
	$ColorRect.hide()

func _on_Spawner_clear():
	set_pop("Wave clear !", 1)


func _on_Player_power_has_change(name_of_boost):
	var ntexture
	
	match(name_of_boost):
		"null":
			ntexture = Tnull
		"speed":
			ntexture = Tspeed
		"double":
			ntexture = Tdouble
		"puls":
			ntexture = Tpuls
	
	get_node("CenterLive/Container/TextureRect").set_texture(ntexture)
