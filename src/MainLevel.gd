extends Node2D
onready var Globals = get_node("/root/Globals")
onready var PLATS = preload("actor/Plat.tscn")

var last_pos = Vector2(0,0)
var temp_pos = Vector2(0,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Camera2D.limit_bottom = 10000000
	$Player/Camera2D.limit_top = 0
	Globals.health = 3
	Globals.list_plat = []
	spawnPlat()
	$Timer.start(1)
	$TempTimer.start(0.1)
	pass # Replace with function body.

func _process(delta):
	#$background.position.y = $Player.position.y + 580

	if temp_pos.y != 0:
		last_pos = temp_pos
	#if Globals.list_plat.size() > 0:
	#	if temp_pos.y > last_pos.y:
	#		last_pos = temp_pos
	#	elif Globals.list_plat[Globals.list_plat.size()-1].position.y > last_pos.y:
	#		last_pos = Globals.list_plat[Globals.list_plat.size()-1].position
	pass

func spawnPlat():
	for n in (15 - Globals.list_plat.size()):
		var PlayerYpos = $Player.position.y
		
		var dis = int($Player.position.y + 500)
		var x = randi() % 700 + 10
		var y = 0
		var base_y = randi() % 250 + 500

		if Globals.list_plat.size() == 0:
			y = randi() % dis + $Player.position.y + 250
			pass
		else:
			y = base_y + last_pos.y
			pass

		var newPlat = PLATS.instance()
		get_node("/root/MainLevel").add_child(newPlat)
		
		newPlat.global_position.x = x
		newPlat.global_position.y = y

		Globals.list_plat.push_back(newPlat)
		last_pos = Globals.list_plat[Globals.list_plat.size()-1].position
		
func spawnPlatO():
	for n in (10 - Globals.list_plat.size()):
		var PlayerYpos = $Player.position.y
		
		var dis = int($Player.position.y + 500)
		var x = randi() % 700 + 10
		var y = randi() % dis + $Player.position.y + 500 # 250

		var newPlat = PLATS.instance()
		get_node("/root/MainLevel").add_child(newPlat)
		
		newPlat.global_position.x = x
		newPlat.global_position.y = y

		Globals.list_plat.push_back(newPlat)
	

func _on_Timer_timeout():
	spawnPlat()


func _on_TempTimer_timeout():
	temp_pos = Vector2(0,0)
	for n in (Globals.list_plat.size()):
		if Globals.list_plat[n].position.y > temp_pos.y:
			temp_pos = Globals.list_plat[n].position
