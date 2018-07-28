extends Control

onready var menus = get_tree().get_nodes_in_group("menu")
var how_to_play_pop_pack = load("res://Scenes/HowToPlay_Screen/HowToPlayScreen.tscn")
var menu_size

var current_point = 0

var c0 = Color("#ffffff")
var c1 = Color("#ffbd68")

func _ready():
	highlight(current_point)
	menu_size = menus.size()

func _process(delta):	
	
	if Input.is_action_just_pressed("ui_up") and current_point - 1 >= 0:
		highlight(current_point - 1)
		$Click.play()
	elif Input.is_action_just_pressed("ui_down") and current_point + 1 <= menu_size - 1:
		highlight(current_point + 1)
		$Click.play()
	
	if Input.is_action_just_pressed("ui_accept"):
		
		$Sound_ui_accept.play()
		
		if current_point == 0:
			$GameStartDelay.start()
			$AnimationPlayer.play("Ui_accept_play")
		elif current_point == 1:
			set_process(false)
			add_child( how_to_play_pop_pack.instance() )
		elif current_point == 2:
			get_tree().quit()

func highlight(menu_id):
	for i in menus:
		i.add_color_override("font_color", c0)
	
	menus[menu_id].add_color_override("font_color", c1)
	current_point = menu_id
	

func _on_GameStartDelay_timeout():
	get_tree().change_scene("res://Scenes/Game/Game.tscn")
