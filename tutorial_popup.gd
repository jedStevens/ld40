extends AcceptDialog

func _ready():
	connect("about_to_show", self, "_on_about_to_show")
	connect("popup_hide", self, "_on_popup_hide")

func set_text(msg):
	$v/p/message.set_text(msg)

func _on_popup_hide():
	omc.unhalt_players()

func _on_about_to_show():
	omc.halt_players()