extends KinematicBody

var active = false

var velocity = Vector3()

var paused = false

export(NodePath) var cam_rig = "../rig"

export(float) var speed = 10

export(int,1,4) var group = 1

func _ready():
	set_physics_process(true)
	active = true

func _physics_process(delta):
	if Input.is_action_just_pressed("tog_"+str(group)):
		active = not active
	
	if active:
		
		var to_move = Vector3()
		
		if Input.is_key_pressed(KEY_UP):
			to_move.z -= 1
		if Input.is_key_pressed(KEY_LEFT):
			to_move.x -= 1
		if Input.is_key_pressed(KEY_DOWN):
			to_move.z += 1
		if Input.is_key_pressed(KEY_RIGHT):
			to_move.x += 1
		
		var cam = get_node(cam_rig)
		
		if cam != null:
			to_move = to_move.rotated(Vector3(0,1,0), cam.rotation.y)
		
		velocity = to_move.normalized() * speed
		
		var col = move_and_slide(velocity)
		
		get_node("walk_wheel").spin(deg2rad(velocity.length()) * 2)
		
		if to_move.length()>0:
			rotation.y = -Vector2(velocity.x, velocity.z).angle()
		