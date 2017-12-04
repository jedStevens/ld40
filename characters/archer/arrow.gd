extends KinematicBody

var direction = Vector3(0,0,-1)

var speed = 10

var p = null
var dest = null

func _ready():
	set_physics_process(true)
	p = $Particles
	dest = get_parent()
	print("particles", p)

func _physics_process(delta):
	var col = move_and_collide(direction.normalized() * speed * delta)
	
	if col != null:
		print("particle_col ",col.collider.get_name())
		
		call_deferred("kill_self")

func kill_self():
	var t = p.global_transform
	remove_child(p)
	get_parent().add_child(p)
	p.global_transform = t
	p.emitting = false
	queue_free()
	omc.delayed_delete(p, 1)
	