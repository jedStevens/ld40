extends Area

export(NodePath)var to_delete=null

func _ready():
	connect("body_entered", self, "on_potential_unlock")

func on_potential_unlock(body):
	if body.is_in_group("player") and body.has_item("key"):
		if to_delete != null:
			get_node(to_delete).queue_free()
		body.get_item("key").queue_free()
		queue_free()