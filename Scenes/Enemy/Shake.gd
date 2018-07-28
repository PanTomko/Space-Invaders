extends Node

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func ded_func():
	get_parent().get_parent().get_parent().emit_signal("A4_ded")
	get_parent().get_node("Ded_sound").play()

func _process(delta):
	if get_parent().status == get_parent().DED:
		ded_func()
		set_process(false)
		

func _on_Ded_sound_finished():
	get_parent().queue_free()
