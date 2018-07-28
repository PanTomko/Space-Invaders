extends Path2D

signal clear
signal A4_ded
signal game_won

onready var alien_packed = { 
	"Alien_01" : load("res://Scenes/Enemy/Alien_01.tscn"), # karaluch
	"Alien_02" : load("res://Scenes/Enemy/Alien_02.tscn"), # green alien
	"Alien_03" : load("res://Scenes/Enemy/Alien_03.tscn"), # fast moving shiet
	"Alien_04" : load("res://Scenes/Enemy/Alien_04.tscn"), # rotaiting guy
	"Alien_09" : load("res://Scenes/Enemy/Boss.tscn") # Boss
}

onready var TBoost = get_parent().get_node("TBoost")

var spawning = true
export var at_pack = int()
var spawn = 1
var spawn_rate = 6 setget set_spawn_rate

func set_spawn_rate(value):
	spawn_rate = value
	$SpawnTime.wait_time = value

onready var packs = { 
	0 : [1,1,1,1,1,1],     
	1 : [1,1,1,2,1,2,1,1,1,2],
	2 : [1,2,3,2,1,2,3,2,1,2,3,2,1,2,3,2,1,2,3,2],
	3 : [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
	4 : [2,2,1,2,2,1,3,3,2,4,2,4,2],
	5 : [2,2,2,4,2,2,2,3,4,2,3,4,4,4,2,2,4,4,3,2,2,2,4,2,4,2,3,2,2,2,2],
	6 : [], # alot of 1
	7 : [9] # boss
}

func add_to(where, what, ile):
	for i in range(ile):
		packs[where] += what

func _ready():
	add_to(6,[1,1],75)
	set_spawn_rate(2)
	spawn = 2
	spawning = false

func spawn(name):
	var alien = alien_packed[name].instance()
	if !alien.is_in_group("boss"):
		randomize()
		$SpawnLocation.unit_offset = rand_range(0,1)
		alien.position = $SpawnLocation.position
	
	alien.spawner = self
	get_node("Aliens").add_child(alien)
	
func _process(delta):
	if spawning == true and get_node("Aliens").get_child_count() == 0 and packs[at_pack].empty():
		emit_signal("clear")
		$TNextWave.start()
		spawning = false
	
func _on_Game_game_start():
	$SpawnTime.start()
	spawning = true
		

func _on_SpawnTime_timeout():
	if spawning == true:
		for i in range(spawn):
			if !packs[at_pack].empty(): 
				spawn("Alien_0" + str(packs[at_pack].pop_front()))


func _on_TNextWave_timeout():
	if at_pack + 1 < packs.size():
		at_pack += 1
		spawning = true
		
		match(at_pack):
			1:
				set_spawn_rate(2.5)
				TBoost.start()
			2:
				spawn = 1
				set_spawn_rate(1.5)
			3:
				spawn = 1
				set_spawn_rate(0.4)
			4:
				spawn = 3
				set_spawn_rate(3)
			5:
				spawn = 3
				set_spawn_rate(2.5)
			6:
				spawn = 1
				set_spawn_rate(0.2)
	else:
		emit_signal("game_won")
