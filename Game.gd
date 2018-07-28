extends Node

signal game_start

onready var backgrounds = get_node("Background").get_children()
export (PackedScene) var lvl_up_scene 
export (PackedScene) var hp_scene
var shake_amount = 0.0

enum states { JUST_STARTED, STARTED, GAME_OVER, GAME_WIN }
var game_state = JUST_STARTED
var time_left = 4

var boost_pack = Array()

var time_in_game = 0

func _exit_tree():
	print(time_in_game/60)

func _ready():
	$Player.position = $StartPos.position
	$GUI.set_pop("Get Redy!")
	$TimerStart.start()
	$ColorRect.hide()
	
	boost_pack.push_back( load("res://Scenes/Boosts/Boost_01.tscn") )
	boost_pack.push_back( load("res://Scenes/Boosts/Boost_02.tscn") )
	boost_pack.push_back( load("res://Scenes/Boosts/Boost_03.tscn") )


func _process(delta):
	time_in_game += delta
	
	if game_state == JUST_STARTED:
		pass
	
	$Camera2D.set_offset(Vector2( rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount ))
	shake_amount -= 20 * delta
	if shake_amount < 0:
		shake_amount = 0
	
	if game_state == GAME_OVER:
		$BackgroundMusic.volume_db -= 3*delta
		
	# Scroling background
	backgrounds[0].region_rect.position.y -= 120 * delta
	backgrounds[1].region_rect.position.y -= 160 * delta
	backgrounds[2].region_rect.position.y -= 180 * delta
	backgrounds[3].region_rect.position.y -= 340 * delta
	
	
func _on_TimerStart_timeout():
	
	time_left -= 1
	
	if time_left > 0: 
		$GUI.update_pop_text( str(time_left) )
	else:
		emit_signal("game_start")
		game_state = STARTED
		$GUI.hide_pop()
		$TimerStart.stop()
		$Timer_LvlUP.start()


func _on_Timer_LvlUP_timeout():
	if $Player.get_node("Wepon").lvl != 3: add_child(lvl_up_scene.instance())
	else: $Timer_LvlUP.stop()

# shake method -- shakes screen on A4(mob) death
func _on_Spawner_A4_ded():
	shake_amount += 10
	if shake_amount > 25:
		shake_amount = 25


func _on_Player_player_ded():
	$AnimationGame.play("Game_over")
	$ColorRect.show()
	game_state = GAME_OVER


func _on_AnimationGame_animation_finished( anim_name ):
	if anim_name == "Game_over":
		get_tree().change_scene("res://Scenes/DeathScreen/DeathScreen.tscn")
	elif anim_name == "game_won":
		get_tree().change_scene("res://Scenes/Main_Menu/Main_Menu.tscn")


func _on_THp_timeout():
	add_child(hp_scene.instance())


func _on_TBoost_timeout():
	randomize()
	var ac = boost_pack[ randi()%boost_pack.size()].instance()
	get_node("BoostContainer").add_child(ac)


func _on_Spawner_game_won():
	$AnimationGame.play("game_won")
	$ColorRect.show()
	game_state = GAME_WIN
