extends Node

onready var menus = get_tree().get_nodes_in_group("menu")
var point = 0

var c0 = Color("#ffffff")
var c1 = Color("#ffbd68")

func _ready():
	set_point(point)

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		if point - 1 >= 0:
			$Click.play()
			point -= 1
			set_point(point)
	elif Input.is_action_pressed("ui_right"):
		if point + 1 <= 1:
			$Click.play()
			point += 1
			set_point(point)
	
	if Input.is_action_just_pressed("ui_accept"):
		var scene
		match(point):
			0:
				get_tree().change_scene("res://Scenes/Game/Game.tscn")
			1:
				get_tree().change_scene("res://Scenes/Main_Menu/Main_Menu.tscn")

func set_point(p):
	for i in menus:
		i.add_color_override("font_color", c0)
	
	menus[p].add_color_override("font_color", c1)
	