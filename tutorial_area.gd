extends Area

export(String) var message = "[No Text]"
var will_show = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_body_entered( body ):
	if body.is_in_group("player") and will_show:
		$tut.set_text(message)
		$tut.popup_centered()
		will_show = false
