extends Spatial


const MAX_HEAT = 1.0

var heat = 0.0

func _ready():
	set_process(true)

func _process(delta):
	for c in get_children():
		c.rotation.z = -rotation.z
	heat -= delta
	

func spin(d):
	heat = min(d*0.1, MAX_HEAT)
	rotate_z(-d)