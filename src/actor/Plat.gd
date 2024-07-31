extends Actor

var count = 0
var inTouch = false

func _ready():
	$Timer.start(0.5)
	pass

func _physics_process(delta: float) -> void:
	vel = calcu_move_vel(vel,speed)
	vel = move_and_slide(vel, Vector2.UP)
	
	#print(self.global_position.y)
	if self.global_position.y - get_node("/root/MainLevel/Player").global_position.y < -680:
		if Globals.list_plat.size() <= 1:
			Globals.list_plat.remove(0)
			queue_free()
		else:
			for s in Globals.list_plat.size()-1:
				if Globals.list_plat[s] != null:
					if Globals.list_plat[s].name == self.name:
						Globals.list_plat.remove(s)
						queue_free()
	else:	
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider is TileMap and Globals.list_plat.size() > 0:
				if Globals.list_plat.size() <= 1:
					Globals.list_plat.remove(0)
					queue_free()
				else:
					for s in Globals.list_plat.size()-1:
						if Globals.list_plat[s] != null:
							if Globals.list_plat[s].name == self.name:
								Globals.list_plat.remove(s)
								queue_free()
			if collision.collider is KinematicBody2D:
				if collision.collider.name == "Player":
					if !inTouch:
						count += 2
						inTouch = true
				else:
					count += 1
				
				for c in 9:
					var visible = 8 - count
					if c > 0 and c <= 8:
						if c <= visible:
							get_node("C"+str(c)).visible = true
						else:
							get_node("C"+str(c)).visible = false
					pass
				
				if count > 8:
					for s in Globals.list_plat.size()-1:
						if Globals.list_plat[s].name == self.name:
							Globals.list_plat.remove(s)
							queue_free()

func calcu_move_vel(liner_vel: Vector2,speed: Vector2) -> Vector2:
	var new_vel: = speed
	new_vel.y += gra * get_physics_process_delta_time()
	
	return new_vel


func _on_Timer_timeout():
	inTouch = false
func test():
	for i in get_slide_count():
		var coll = get_slide_collision(i)
		if coll.collider is KinematicBody2D and coll.collider.name == "Player":
			pass
		else:
			for e in get_slide_count():
				var collision = get_slide_collision(e)
				if collision.collider is TileMap and Globals.list_plat.size() > 0:
					for s in Globals.list_plat.size()-1:
						if Globals.list_plat[s] == null:
							pass
						else:
							if Globals.list_plat[s].name == self.name:
								Globals.list_plat.remove(s)
								queue_free()
