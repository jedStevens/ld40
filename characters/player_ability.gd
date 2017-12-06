extends Node

var timer = Timer.new()

export(float) var cooldown_time = 3.0
export(int) var mana_cost = 12
export(Texture) var icon = preload("res://ui/no_ability.png")

export(NodePath)var  player =null
var obj = null

var ui = null

func _ready():
	timer.connect("timeout", self, "timer_done")
	if player != null:
		obj = get_node(player)
	add_child(timer)

func activate():
	timer.wait_time = cooldown_time
	timer.start()
	set_process(true)
	
	if obj != null:
		on_activate()

func timer_done():
	set_process(false)
	timer.stop()
	on_cooldown_over()

func _process(delta):
	if ui != null:
		ui.set_cd((timer.get_time_left() / cooldown_time) * 100)

func on_activate():
	pass

func off_cd():
	return timer.is_stopped()

func get_time_left():
	return 0

func on_cooldown_over():
	pass