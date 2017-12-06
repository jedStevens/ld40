extends KinematicBody

const MIN_ONAIR_TIME = 0.01

var SleepPar = preload("res://characters/sleeping.tscn")

export(bool) var selected = false
var in_party = false

var velocity = Vector3()
var additional_vel = Vector3()

export(NodePath) var cam_rig = "../rig"

export(float) var speed = 10

export(float) var turn_rate = 6
export(float) var reactiveness = 60

export(float) var mana_regen_rate = 1
export(float) var hp_regen_rate = 1

export(bool) var sleeping = false setget set_sleeping

export(int,0,2) var group = 0

var halted = false

var target = Vector2(1,0)

export(Texture) var portrait_texture = null

var onair_time = 0
var on_floor = false

export(NodePath) var arm_wheel = null

var mana = 100
var hp = 100

var ui = null

func _ready():
	set_physics_process(true)
	$marker.visible = selected
	
	$vn.connect("screen_exited", self, "on_off_screen")
	
	$party_up.connect("body_entered", self, "_on_party_up_body_entered")

func _physics_process(delta):
	velocity = move_and_slide(velocity + additional_vel, Vector3(0,1,0))
	additional_vel *= 0.5
	
	mana += delta * mana_regen_rate
	hp += delta * hp_regen_rate
	if ui != null:
		ui.set_hp(hp)
		ui.set_alt(mana)
	
	if is_on_floor():
		onair_time = 0
	
	on_floor = onair_time < MIN_ONAIR_TIME
	
	velocity += Vector3(0,-50.0 * delta,0)
	if halted:
		velocity.x = 0
		velocity.z = 0
		return
	
	
	if selected and in_party:
		
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
		
		
		velocity = velocity.linear_interpolate(to_move.normalized() * speed,delta * reactiveness)
		velocity += Vector3(0,-700,0) * delta
		
		if velocity.length() > 0:
			var hvel = Vector3(velocity.x, 0, velocity.z)
			$char/walk_wheel.spin(deg2rad(hvel.length()) * 2)
			if arm_wheel != null:
				$char/arm_wheel.spin(deg2rad(hvel.length()) * 2)
		
		if to_move.length()>0:
			target = target.linear_interpolate(Vector2(to_move.z,to_move.x), delta * turn_rate)
		rotation.y = target.angle()
	elif in_party:
		velocity *= 0.75
		var sum = Vector3()
		var i = 0
		for p in omc.players:
			if p == null:
				continue
			
			sum += p.global_transform.origin
			i+= 1
		if i!=0:
			sum = sum / i
			if not sleeping:
				var m = omc.get_players_mid_point()
				rotation.y = (-Vector2(global_transform.origin.z-m.z,global_transform.origin.x-m.x)).angle()
	else:
		velocity *= 0.75
		set_sleeping(true)
	
	if $items.get_child_count() > 0:
		var gap = 2 * PI / $items.get_child_count()
		var a = 0
		for c in $items.get_children():
			
			c.transform.origin = Vector3(sin(a), 0, cos(a))
			a+=gap
		$items.global_transform.basis = $items.global_transform.rotated(Vector3(0,1,0),delta).basis
	

func pick_up_item(i):
	i.get_parent().remove_child(i)
	$items.add_child(i)
	i.set_mode(RigidBody.MODE_KINEMATIC)
	i.held = true

func set_selected(b):
	if (selected and not b) or (not selected and b):
		get_node(("de" if b else "") + "select").play()
	selected = b
	$marker.visible = selected
	if b :
		set_sleeping(false)
	

func is_selected():
	return selected
func set_party(b):
	in_party = b
	if not b:
		set_selected(false)
		set_sleeping(true)

func _on_party_up_body_entered( body ):
	if in_party and body.is_in_group("player") and body != self:
		omc.party_up(body)

#godot typo
func _on_visiblity_screen_exited():
	omc.kick(self)
	set_party(false)

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

func on_off_screen():
	omc.kick(self)
	set_party(false)

func use_ability(i):
	if $abilities.get_child_count() <= i:
		print("man, I wish I could use my ability: ", i)
	else:
		var a = $abilities.get_child(i)
		if a.mana_cost > mana or not a.off_cd():
			return
		else:
			$abilities.get_child(i).activate()
			mana -= a.mana_cost

func has_item(tag):
	for c in $items.get_children():
		if c.is_in_group(tag):
			return true

func get_item(tag):
	for c in $items.get_children():
		if c.is_in_group(tag):
			return c

func channel(time, o, f):
	var t = Timer.new()
	t.autostart = true
	t.wait_time = time
	t.one_shot = true
	t.connect("timeout", o,f)
	halt()
	add_child(t) 