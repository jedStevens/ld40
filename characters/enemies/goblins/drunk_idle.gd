extends "res://characters/enemies/ai_node.gd"

func exec_ai(delta):
	if ai_obj != null:
		ai_obj.rotate_y(PI * delta * 12)
		ai_obj.ai_move((Vector3(0,0,1).rotated(Vector3(0,1,0), ai_obj.rotation.y)), delta)
		if randf() < 0.01:
			fsm.set_state("hiccup")