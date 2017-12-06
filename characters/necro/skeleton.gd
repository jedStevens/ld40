extends "res://characters/player_ability.gd"

func on_activate():
	obj.channel(2.0, self, "spawn_fire_demon")

func spawn_fire_demon():
	var fire_demon = preload("res://characters/necro/fire_demon/fire_demon.tscn").instance()
	obj.get_parent().add_child(fire_demon)
	fire_demon.global_transform = obj.global_transform + obj.global_transform.basis[0] * 2