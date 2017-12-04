extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$tut.set_text("Aroow Keys to Move\nYou will move anyone who is 'selected' in your party.\nSpace to close this.")
	$tut.popup_centered()
	omc.hp_panel = get_node("../hp")
	omc.party_up(get_node("../archer"))
	omc.halt_players()