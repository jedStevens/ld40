extends "res://characters/player_ability.gd"

export(float) var channel_time = 1.0

func on_activate():
	obj.channel(channel_time, self, "spawn_fire_demon")

func spawn_fire_demon():
	var fire_demon = preload("res://characters/necro/fire_demon/fire_demon.tscn").instance()
	obj.get_parent().add_child(fire_demon)
	fire_demon.global_transform = obj.global_transform 
	fire_demon.global_transform.origin = obj.global_transform.origin + obj.global_transform.basis[0] * 2
	obj.unhalt()