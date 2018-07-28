extends Node

var exit = false

func _exit_tree():
	get_parent().set_process(true)

func _ready():
	pass

func _input(event):
		if event.is_pressed():
			$Animation_HTP.play_backwards("on_enter")
			exit = true


func _on_Animation_HTP_animation_finished( anim_name ):
	if exit == true:
		queue_free()
