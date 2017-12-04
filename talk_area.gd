extends Area

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_pop_up_about_to_show():
	omc.halt_players()

func _on_pop_up_popup_hide():
	omc.unhalt_players()
	queue_free()

func _on_body_entered( body ):
	if body.is_in_group("player") and body != get_parent():
		$pop_up.popup_centered()
