extends KinematicBody

var direction = Vector3(0,0,-1)

var speed = 10

var p = null
var dest = null

var damage = 10

func _ready():
	set_physics_process(true)
	p = $Particles
	dest = get_parent()
	direction = global_transform.basis.xform(direction)

func _physics_process(delta):
	var col = move_and_collide(direction.normalized() * speed * delta)
	
	if col != null and not col.collider.is_in_group("player"):
		if col.collider.is_in_group("enemy"):
			col.collider.damage(damage)
		
		call_deferred("kill_self")

func kill_self():
	var t = p.global_transform
	remove_child(p)
	get_parent().add_child(p)
	p.global_transform = t
	p.emitting = false
	queue_free()
	omc.delayed_delete(p, 1)
	