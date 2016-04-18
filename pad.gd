
extends KinematicBody2D

var oldPos = Vector2()



var input_states = preload("res://input_states.gd")
var lmb = input_states.new("LMB")
var rmb = input_states.new("RMB")
var mmb = input_states.new("MMB")


func _ready():
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	var mPos = get_viewport().get_mouse_pos()
	var pos = get_pos()
	
	if mPos.x>100 and mPos.x<380:
		move_to(Vector2(mPos.x,732))
		
	if mPos.y > 780:
		Input.warp_mouse_pos(Vector2(mPos.x,780))
	if mPos.y < 10:
		Input.warp_mouse_pos(Vector2(mPos.x,10))
	if mPos.x > 475:
		Input.warp_mouse_pos(Vector2(470,mPos.y))
	if mPos.x < 5:
		Input.warp_mouse_pos(Vector2(10,mPos.y))
		
	
	if lmb.check() == 2 and rmb.check() == 2:
		if pos.y < 745:
			#move_to(Vector2(mPos.x,pos.y+3))
			move_local_y(6)
			
		
	if lmb.check() == 2 and rmb.check() == 0:
		if get_rot() < 0.3:
			rotate(0.1)
	if rmb.check() == 2 and lmb.check() == 0:
		if get_rot() > -0.3:
			rotate(-0.1)
			
	if lmb.check() == 0 and rmb.check() == 0:
		move_to(Vector2(mPos.x,732))
		set_rot(0)
		
		
	



	
	


