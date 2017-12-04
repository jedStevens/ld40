extends "ai_node.gd"

func exec_ai(delta):
	ai_obj.ai_look_at(omc.get_players_mid_point())