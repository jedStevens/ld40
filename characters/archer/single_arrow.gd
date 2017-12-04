extends "res://characters/player_ability.gd"

var Arrow = preload("res://characters/archer/arrow.tscn")

func on_activate():
	var p = obj.get_parent()
	
	var node = Arrow.instance()
	var v = obj.global_transform.basis.xform(Vector3(0,0,3))
	p.add_child(node)
	node.global_transform = obj.get_node("new_arrow_pos").global_transform
	node.direction = obj.global_transform.basis[2]