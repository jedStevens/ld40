extends Spatial

export(NodePath) var player_base = ".."
func _ready():
	set_process(true)
	omc.rig = self

func _process(delta):
	if omc.is_any_selected():
		var diff = omc.get_players_selected_mid_point() - omc.get_players_mid_point()
		var sum = omc.get_players_mid_point() + diff * 0.6
		global_transform.origin = global_transform.interpolate_with(Transform(global_transform.basis, sum),delta * 7).origin

func get_camera():
	return $Camera