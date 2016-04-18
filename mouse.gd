
extends RigidBody2D

var input_states = preload("res://input_states.gd")
var lmb = input_states.new("LMB")
var rmb = input_states.new("RMB")
var touch = false
var speed = 310

var resetTimer = 0
var death = false

export var cheeseLeft = 26
var score = 0
var lives = 3
var cheeseCount = 0
var cheeseTimer = 0
var startCT = false

var pos = Vector2()
var oldPos = Vector2()
var movement = Vector2()
var leftRight = ""
var leftRightPre = ""
var leftRightNext = "right"
var upDown = ""
var upDownPre = ""
var upDownNext = "down"

var rot = 0.0
var oldRot = 0.0
var rotChange = 0.0
var highRot = false

var aniPlayer = null
var ani = ""
var aniNew = ""

var exit = false

#var cheeseTaken = preload("res://cheeseTaken.scn")
#var cheeseTakenCount = 0
var combo = preload("res://combo.scn")

var speedupTimer = 0.0
var speedup = 1.0
var speedupTstart = false


func _ready():

	set_fixed_process(true)
	
	aniPlayer = get_node("aniMouse")
	
func _fixed_process(delta):
	
	upDownPre = upDown
	upDown = upDownNext
	
	leftRightPre = leftRight
	leftRight = leftRightNext
	
	if ani != aniNew:
		aniNew = ani
		aniPlayer.play(ani)
	
	#movement detect
	pos = get_pos()
	movement = (pos - oldPos)
	oldPos = pos
	
	if movement.x < 0:
		leftRightNext = "left"
	else:
		leftRightNext = "right"
	if movement.y < 0:
		upDownNext = "up"
	else:
		upDownNext = "down"
		
	#rotation detect
	rot = get_rot()
	rotChange = rot-oldRot
	if rotChange > 0.1 or rotChange < -0.1:
		highRot = true
	else:
		highRot = false
	oldRot = rot
	
	#orientation
	#left-right
	if leftRight == "right" and leftRightNext == "left" and death == false:
		set_scale(get_scale() * Vector2(-1,get_scale().y))
	elif leftRight == "left" and leftRightNext == "right" and death == false:
		set_scale(get_scale() * Vector2(1,get_scale().y))
		
	#up-down
	if upDown == "down" and upDownNext == "up" and death == false:
		set_scale(get_scale() * Vector2(get_scale().x,-1))
	elif upDown == "up" and upDownNext == "down" and death == false:
		set_scale(get_scale() * Vector2(get_scale().x,1))
		
	if highRot == true:
		ani = "rot"
	else:
		ani = "idle"
	
	if cheeseLeft == 0 and exit == false:
		get_parent().get_node("hud/complete").show()
		get_node("sfx").play("woohoo")
		exit = true
	if exit == true or death == true:
		if Input.is_action_pressed("ui_accept"):
			get_tree().reload_current_scene()
		if Input.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene("res://spash.scn")
	
	if startCT ==true:
		cheeseTimer += 1
		if cheeseTimer > 40:
			startCT = false
			cheeseTimer = 0
			cheeseCount = 0
	
	if lmb.check() == 3 or rmb.check() == 3:
		speedupTstart = true
	if lmb.check() == 0 and rmb.check() == 0 and speedupTstart == true:
		speedupTimer += delta
		if speedupTimer < 0.4:
			speedup = 1.2
		if speedupTimer > 0.4:
			speedupTimer = 0.0
			speedupTstart = false
			speedup = 1.0
			
		
	


func _integrate_forces(state):
	
	if touch == true:
		var mousePos = get_global_pos()
		var padPos = get_parent().get_node("pad").get_global_pos()
		var padToMouse = (mousePos - padPos).normalized()
		set_linear_velocity(padToMouse * (speed*speedup))
		touch = false
		
	if death == true or exit == true:
		set_linear_velocity(get_linear_velocity()/2)
		
		


func _on_RigidBody2D_body_enter( body ):
	if body.is_in_group("pad"):
		touch = true
		get_parent().get_node("Camera2D/camShaker").play("pad")
		get_node("sfx").play("pad")
		#var randHop = randi() % 3
		#if randHop == 1:
		#	get_node("sfx").play("hop")
		
	if body.is_in_group("cheese"):
		startCT = true
		#cheeseCount += 1
		get_parent().get_node("Camera2D/camShaker").play("camShake")
		body.taken = true
		cheeseLeft -= 1
		get_node("sfx").play("cheese")
		if cheeseTimer < 40:
			cheeseCount += 1
		if cheeseCount == 1:
			score += 100
		if cheeseCount > 1:
			score = score + (100 * cheeseCount)
			get_node("sfx").play("yeah")
			
		
		
		
		
		
	#if body.is_in_group("cheese200"):
	#	score += 200
	#	set_linear_velocity(get_linear_velocity() * 1.2)
	#	body.queue_free()
	
	if body.is_in_group("death"):
		resetTimer += 1
		set_linear_velocity(Vector2(0,0))
		if death == false and exit == false:
			get_parent().get_node("Camera2D/camShaker").play("death")
			lives -= 1
			get_node("sfx").play("no")
			get_node("sfx").play("hit")
			get_node("blood").set_emitting(true)
			death = true
			get_parent().get_node("hud/gameOver").show()
		if resetTimer > 30:
			hide()
			
	if body.is_in_group("stage"):
		get_parent().get_node("Camera2D/camShaker").play("smallShake")
		get_node("sfx").play("hit")
		
