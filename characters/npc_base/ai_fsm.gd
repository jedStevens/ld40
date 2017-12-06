extends Node

export(String) var current_state = "no_state"

export(NodePath) var ai_obj = null

func _ready():
	set_ai_obj(ai_obj)
	
	for c in get_children():
		c.set_fsm(self)
	
	set_state(current_state)

func set_state(new_state):
	current_state = new_state
	get_node(current_state).on_start()
	# monitor for transitions here

func set_ai_obj(new_obj):
	for c in get_children():
		c.set_ai_obj(get_node(new_obj))

func exec_ai(delta):
	if get_node(current_state) != null and get_node(current_state).has_method("exec_ai"):
		get_node(current_state).exec_ai(delta)
