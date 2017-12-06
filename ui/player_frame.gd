extends Control

func set_player(player):
	set_portrait(player.get_portrait())
	var i = 0
	for ab in player.get_node("abilities").get_children():
		set_ability(ab, i)
		i+=1
	player.ui = self

func set_portrait(t):
	$portrait.texture = t
func clear_portrait():
	$portrait.texture = preload("res://ui/hp_backing.png")

func set_ability(ab, i):
	get_node("abilities").get_child(i).set_ability(ab)
	
func clear_abilities():
	for ab in $abilities.get_children():
		ab.set_icon(preload("res://ui/no_ability.png"))

func set_hp(new_hp):
	$health.value = new_hp

func set_alt(new_alt):
	$alt.value = new_alt

func clear():
	clear_portrait()
	clear_abilities()