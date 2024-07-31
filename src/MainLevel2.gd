extends Node2D
onready var Globals = get_node("/root/Globals")
onready var PLATS = preload("actor/PlatTrap.tscn")


var last_pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.health = 3
	Globals.list_plat = []
	$Player/Camera2D.limit_bottom = 0
	$Player/Camera2D.limit_top = -10000000
	spawnPlat(Vector2(100,0))
	#$Timer.start(1)
	pass # Replace with function body.

func _process(delta):
	if last_pos is Vector2 and Globals.list_plat.size() != 0:
		last_pos = Globals.list_plat[Globals.list_plat.size()-1].position
		if $Player.position.distance_to(Globals.list_plat[Globals.list_plat.size()-1].position) < 1280:
			spawnPlat(last_pos)
	#$background.position.y = $Player.position.y - 580

func spawnPlat(base_pos: Vector2):
	for n in 11:
		var PlayerYpos = $Player.position.y
		var dis = -207
		var base_x = 100
		var base_y = 0
	
		var x = 0
		var y = 0
		
		
		if n <= 5:
			x = base_x * n * 1 + 150
			base_y = dis + base_pos.y 
		else:
			x = 1150 - base_x * n
			base_y = dis + base_pos.y - 35
			
		
		y = base_y + -32 + (-n * 175)
		
		
		var newPlat = PLATS.instance()
		get_node("/root/MainLevel2").add_child(newPlat)
			
		newPlat.global_position.x = x
		newPlat.global_position.y = y

		if n == 10:
			last_pos = newPlat.global_position
		Globals.list_plat.push_back(newPlat)
func spawnPlatO():
	for n in (10 - Globals.list_plat.size()):
		var PlayerYpos = $Player.position.y
		
		var dis = int($Player.position.y - 500)
		
		var x = randi() % 700 + 10
		var y = randi() % dis + $Player.position.y - 1280
	
		var newPlat = PLATS.instance()
		get_node("/root/MainLevel2").add_child(newPlat)
		
		newPlat.global_position.x = x
		newPlat.global_position.y = y

		Globals.list_plat.push_back(newPlat)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
