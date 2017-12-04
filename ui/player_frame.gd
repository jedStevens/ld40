extends Control

func set_portrait(t):
	$portrait.texture = t
func clear_portrait():
	$portrait.texture = preload("res://ui/hp_backing.png")