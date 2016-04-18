
extends Node2D

var cheese

func _ready():
	set_process(true)
	
func _process(delta):
	
	cheese = get_parent().get_parent().get_parent().get_node("mouse").cheeseCount
	get_node("comboCount").set_text("x"+str(cheese))


