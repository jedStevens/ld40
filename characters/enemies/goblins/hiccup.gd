extends "res://characters/enemies/ai_node.gd"

var timer = 0
var delay = 0.6

func on_start():
	timer = delay

func exec_ai(delta):
	ai_obj.velocity = Vector3()
	timer -= delta
	if timer < 0:
		fsm.set_state("drunk_idle")