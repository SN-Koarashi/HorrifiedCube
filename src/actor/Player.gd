extends Actor

var jump_pos = Vector2(0,0)
var stay_pos = Vector2(0,0)

var jump_pos_sc = Vector2(0,0)
var stay_pos_sc = Vector2(0,0)

var click = false
var entered = false
var autoJump = false 
var tap_plat = 0
var tap_plat_total = 0
var temp_gra = gra
var temp_score_y = 0
var inSky = 0
var dragMode = false

enum STATES {
	MoveRightSmooshy,
	MoveLeftSmooshy,
	MoveRight,
	MoveLeft,
	MoveTop,
	MoveDown,
	Idle
}
onready var state = STATES.Idle
onready var stateY = STATES.Idle
onready var DragBtn = $Camera2D/CanvasLayer/DragBtn #This should reference your button
## x 10~ 710
# y 20

onready var origion = DragBtn.get_position()

func _ready():
	var RealSize = OS.get_real_window_size()
	var NowSize = OS.get_window_safe_area()
	var notchSizeY = RealSize.y - NowSize.size.y

	if notchSizeY >= 5:
		$Camera2D/CanvasLayer/ScoreMenu.rect_position.y = notchSizeY
		$Camera2D/CanvasLayer/HPGUI.rect_position.y = notchSizeY + 15
		$Camera2D/CanvasLayer/pause.rect_position.y = notchSizeY + 15
	else:
		$Camera2D/CanvasLayer/ScoreMenu.rect_position.y = notchSizeY + 30
		$Camera2D/CanvasLayer/HPGUI.rect_position.y = notchSizeY + 45
		$Camera2D/CanvasLayer/pause.rect_position.y = notchSizeY + 45
	
	Globals.Score = 0
	origion[0] += 75
	origion[1] += 75
	
	match Globals.gamemode:
		"UP":
			autoJump = false
			pass
		"DOWN":
			autoJump = true
			pass
	pass # Replace with function body.

func _process(delta):

	if Globals.gamemode == "UP":
		var score_now_y = floor((abs($Player.global_position.y) - 32)  / 10)
		
		if score_now_y > temp_score_y:
			Globals.Score = score_now_y + tap_plat_total * 10
			temp_score_y = score_now_y
		
		#Globals.Score = tap_plat_total * 5 + floor((abs($Player.global_position.y) - 32)  / 10)
	else:
		var score_now_y = floor((abs($Player.global_position.y) - 79) / 100)
		
		if score_now_y > temp_score_y:
			Globals.Score = score_now_y + tap_plat_total * 5
			temp_score_y = score_now_y
		
	if tap_plat >= 8 and Globals.health < 3:
		tap_plat = 0
		Globals.health += 1
		pass
	match Globals.health:
		3:
			$Camera2D/CanvasLayer/HPGUI/HP3.visible = true
			$Camera2D/CanvasLayer/HPGUI/HP2.visible = true
			$Camera2D/CanvasLayer/HPGUI/HP1.visible = true
		2:
			$Camera2D/CanvasLayer/HPGUI/HP3.visible = false
			$Camera2D/CanvasLayer/HPGUI/HP2.visible = true
			$Camera2D/CanvasLayer/HPGUI/HP1.visible = true
		1:
			$Camera2D/CanvasLayer/HPGUI/HP3.visible = false
			$Camera2D/CanvasLayer/HPGUI/HP2.visible = false
			$Camera2D/CanvasLayer/HPGUI/HP1.visible = true
		0:
			queue_free()
			get_tree().change_scene("res://src/GameOver.tscn")


	if entered:
		gra = 0
		vel.y = -850
		inSky = 0
	elif is_on_wall():
		inSky = 0
	elif is_on_floor():
		inSky = 0
	else:
		gra = temp_gra
		inSky += 1

	if self.global_position.x > 710:
		self.global_position.x = 705
	if self.global_position.x < 10:
		self.global_position.x = 15

	$Camera2D/CanvasLayer/ScoreMenu/Label.text = str(Globals.Score)
	
	if inSky < 120:
		$Light2D.color = "#ffef00"
		$Light2D.energy = 1.5
	elif inSky < 180:
		$Light2D.color = "#ff0000"
		$Light2D.energy = 2.5
	else:
		queue_free()
		get_tree().change_scene("res://src/GameOver.tscn")

# Declare member variables here. Examples:
func _input(event):
	if event is InputEventScreenDrag and dragMode:
		var angle = origion.angle_to_point(event.get_position())

		if angle >= -1 and angle < 0.4:
			#print("left")
			state = STATES.MoveLeft
			stateY = STATES.Idle
			DragBtn.set_position(Vector2(origion[0]-75-25,origion[1]-75))
			pass #left
		elif angle >= 0.4 and angle < 1.4:
			#print("leftTop")
			state = STATES.MoveLeft
			stateY = STATES.MoveTop
			DragBtn.set_position(Vector2(origion[0]-75-25,origion[1]-75-25))
			pass #leftTop
		elif angle <= -2 or angle >= 2.8:
			#print("right")
			state = STATES.MoveRight
			stateY = STATES.Idle
			DragBtn.set_position(Vector2(origion[0]-75+25,origion[1]-75))
			pass #right
		elif angle >= 1.8 and angle < 2.8:
			#print("rightTop")
			state = STATES.MoveRight
			stateY = STATES.MoveTop
			DragBtn.set_position(Vector2(origion[0]-75+25,origion[1]-75-25))
			pass #rightTop
		elif angle >= 1.4 and angle < 1.8:
			#print("top")
			
			if stateY == STATES.MoveTop:
				if state == STATES.MoveRight:
					state = STATES.MoveRightSmooshy
					pass
				elif state == STATES.MoveLeft:
					state = STATES.MoveLeftSmooshy
					pass
				else:
					state = STATES.Idle
					pass
				stateY = STATES.MoveTop
			else:
				stateY = STATES.MoveTop
				state = STATES.Idle
				pass
				
			DragBtn.set_position(Vector2(origion[0]-75,origion[1]-75-25))
			pass #top
		else:
			stateY = STATES.Idle
			state = STATES.Idle
			DragBtn.set_position(Vector2(origion[0]-75,origion[1]-75))
			pass #idle
			
	if event is InputEventScreenTouch:
		var rect = $Camera2D/CanvasLayer/pause.get_rect()
		
		if !rect.has_point(event.position):
			if event.pressed:
				DragBtn.set_position(Vector2(event.position.x -75,event.position.y - 75))
				origion = event.position
				dragMode = true
				DragBtn["custom_styles/normal"].bg_color = Color("#80303030")
				DragBtn["custom_styles/normal"].border_blend = true
			else:
				dragMode = false
				DragBtn["custom_styles/normal"].bg_color = Color("#c3201f1f")
				DragBtn["custom_styles/normal"].border_blend = false
			
func calcu_move_vel(liner_vel: Vector2,dir: Vector2,speed: Vector2) -> Vector2:
	var new_vel: = liner_vel
	new_vel.x = speed.x * dir.x
	if !entered:
		new_vel.y += gra * get_physics_process_delta_time()
	if dir.y == -1.0:
		new_vel.y = speed.y * dir.y
	return new_vel

func _physics_process(delta: float) -> void:
	var dir: = get_dir()
	vel = calcu_move_vel(vel,dir,speed)
	vel = move_and_slide(vel, Vector2.UP)
	
	
	
	if !dragMode:
		stateY = STATES.Idle
		state = STATES.Idle
		DragBtn.set_position(Vector2(origion[0]-75,origion[1]-75))
	
	#for i in get_slide_count():
	#	var collision = get_slide_collision(i)
	#	if collision.collider is KinematicBody2D:
	#		gra = collision.collider.gra

func get_dir() -> Vector2:
	var inVel = Vector2(0,0)
	match state:
		STATES.MoveRightSmooshy:
			inVel.x = -0.5
		STATES.MoveLeftSmooshy:
			inVel.x = 0.5
		STATES.MoveRight:
			inVel.x = 1
		STATES.MoveLeft:
			inVel.x = -1
		STATES.MoveTop:
			inVel.y = -1
		STATES.MoveDown:
			inVel.y = 1
		STATES.Idle:
			inVel.x = 0

	if stateY == STATES.MoveTop and is_on_floor():
		inVel.y = -1
	else:
		inVel.y = 1
	return inVel
		
func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		if abs(body.position.y) > abs(stay_pos_sc.y):
			stay_pos_sc = body.position
			tap_plat_total += 1
			
		stay_pos = body.position
		if abs(stay_pos.y) > abs(jump_pos.y):
			tap_plat += 1
		if autoJump:
			entered = true
		pass
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		if abs(body.position.y) > abs(jump_pos_sc.y):
			jump_pos_sc = body.position
		jump_pos = body.position
		entered = false
	pass # Replace with function body.


func _on_Button_pressed():
	$Camera2D/CanvasLayer/PauseMenu.visible = true
	get_tree().paused = true
	pass # Replace with function body.


func _on_continue_pressed():
	$Camera2D/CanvasLayer/PauseMenu.visible = false
	get_tree().paused = false
	pass # Replace with function body.
