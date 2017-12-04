extends KinematicBody

const MIN_ONAIR_TIME = 0.01

var SleepPar = preload("res://characters/sleeping.tscn")

var velocity = Vector3()

export(float) var speed = 3

export(float) var turn_rate = 2
export(float) var reactiveness = 1

export(bool) var sleeping = false setget set_sleeping

var halted = false

var target = Vector2(1,0)

export(Texture) var portrait_texture = null

var onair_time = 0
var on_floor = false

var hp = 15

export(NodePath) var arm_wheel = null

func _ready():
	set_physics_process(true)
func _physics_process(delta):
	
	$hp.set_global_position(omc.rig.get_camera().unproject_position($hp_pos.global_transform.origin))
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_on_floor():
		onair_time = 0
	
	on_floor = onair_time < MIN_ONAIR_TIME
	
	velocity += Vector3(0,-50.0 * delta,0)
	if halted:
		velocity.x = 0
		velocity.z = 0
		return
	
	if get_node("ai_fsm") != null:
		get_node("ai_fsm").exec_ai(delta)
	
	$hp/bar.value = hp
	
	if $items.get_child_count() > 0:
		var gap = 2 * PI / $items.get_child_count()
		var a = 0
		for c in $items.get_children():
			
			c.transform.origin = Vector3(sin(a), 0, cos(a))
			a+=gap
		$items.global_transform.basis = $items.global_transform.rotated(Vector3(0,1,0),delta).basis
	
	if hp <= 0:
		call_deferred("kill_self")
func pick_up_item(i):
	i.get_parent().remove_child(i)
	$items.add_child(i)
	i.set_mode(RigidBody.MODE_KINEMATIC)
	i.held = true
func kill_self():
	for c in $items.get_children():
		var t = c.global_transform
		$items.remove_child(c)
		get_parent().add_child(c)
		c.global_transform = t
		c.set_mode(RigidBody.MODE_RIGID)
		c.held = false
	queue_free()

func ai_move(to_move, delta):
	velocity = velocity.linear_interpolate(to_move.normalized() * speed,delta * reactiveness)
	
	if velocity.length() > 0:
		var hvel = Vector3(velocity.x, 0, velocity.z)
		$char/walk_wheel.spin(deg2rad(hvel.length()) * 2)
		if arm_wheel != null:
			$char/arm_wheel.spin(deg2rad(hvel.length()) * 2)
	
	if to_move.length()>0:
		target = target.linear_interpolate(Vector2(to_move.z,to_move.x), delta * turn_rate)
	rotation.y = target.angle()

func ai_look_at(p):
	rotation.y = (-Vector2(global_transform.origin.z-p.z,global_transform.origin.x-p.x)).angle()

func halt():
	halted = true
func unhalt():
	halted = false

func set_sleeping(b):
	if not b and get_node("char/head/sleeping") != null:
		sleeping = b
		var sleep_part = $char/head/sleeping
		if sleep_part == null:
			return
		
		$char/head.remove_child(sleep_part)
	elif b and not sleeping:
		var sleeping_p = SleepPar.instance()
		get_node("char/head").add_child(sleeping_p)
		sleeping = b
		
func get_portrait():
	return portrait_texture

func damage(d):
	hp -= d