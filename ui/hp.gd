extends HBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)
	omc.hp_panel = self

func _process(delta):
	margin_right = get_viewport_rect().size.x

func player_set_at(player, pos):
	get_child(pos).set_portrait(player.get_portrait())