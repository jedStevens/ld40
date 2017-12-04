extends Node

var timer = Timer.new()

export(float) var cooldown_time = 3.0
export(int) var mana_cost = 12
export(Texture) var icon = null

export(NodePath)var  player =null
var obj = null

func _ready():
	timer.connect("timeout", self, "on_cooldown_over")
	if player != null:
		obj = get_node(player)

func activate():
	timer.wait_time = cooldown_time
	timer.start()
	
	if obj != null:
		on_activate()

func on_activate():
	pass

func is_ready():
	return timer.get_time_left() > 0

func get_time_left():
	return 0

func on_cooldown_over():
	pass