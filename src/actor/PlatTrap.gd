extends Actor

var count = 0

func _ready():
	#$Timer.start(3)
	pass

func _physics_process(delta: float) -> void:
	vel = calcu_move_vel(vel,speed)
	vel = move_and_slide_with_snap(vel, Vector2.UP)
	
	#print(self.global_position.y)
	#print(self.global_position.y - get_node("/root/MainLevel2/Player").global_position.y)
	if self.global_position.y - get_node("/root/MainLevel2/Player").global_position.y > 680:
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
				if collision.collider.name != "Player":
					count += 2
				else:
					count += 1
				
				if count > 8:
					for s in Globals.list_plat.size()-1:
						if Globals.list_plat[s].name == self.name:
							Globals.list_plat.remove(s)
							queue_free()
	
func calcu_move_vel(liner_vel: Vector2,speed: Vector2) -> Vector2:
	var new_vel: = speed
	new_vel.y += gra * get_physics_process_delta_time()
	
	return new_vel


func _on_HitBox_body_entered(body):
	if body.name == "Player":
		count -= 1
		body.vel.y = 750
		Globals.health -= 1
		pass
