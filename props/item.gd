extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var held = false

func _ready():
	$pickup.connect("body_entered", self, "on_potential_pickup")

func on_potential_pickup():
	for body in get_colliding_bodies():
		if body.is_in_group("player"):
			body.pick_up_item(self)
			return
		elif body.is_in_group("enemy"):
			body.pick_up_item(self)
			return

func _on_pickup_body_entered( body ):
	if held:
		return
	if body.is_in_group("player"):
		body.pick_up_item(self)
		return
	elif body.is_in_group("enemy"):
		body.pick_up_item(self)
		return
