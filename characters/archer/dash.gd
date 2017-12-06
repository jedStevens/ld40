extends "res://characters/player_ability.gd"

func on_activate():
	obj.additional_vel = obj.global_transform.basis[2].normalized() * obj.speed * 2