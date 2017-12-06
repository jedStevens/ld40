extends Node

const MAX_PARTY_SIZE = 4

var players = []

var party_buttons = ["tog_1", "tog_2", "tog_3", "tog_4"]

var ability_actions = ["ab_Q", "ab_W", "ab_E"]

var halted = false

var hp_panel = null

var rig = null

func _ready():
	for p in range(MAX_PARTY_SIZE):
		players.append(null)
	
	set_process(true)

func _process(delta):
	if halted:
		return
	else:
		if Input.is_action_just_pressed("toggle_all"):
			
			var b= is_any_selected()
			
			for p in players:
				if p == null:
					continue
				p.set_selected(not b)
		
		for i in range(players.size()):
			if players[i] == null:
				continue
			if Input.is_action_just_pressed(party_buttons[i]):
				players[i].set_selected(not players[i].is_selected())
		
		for aa in ability_actions:
			if Input.is_action_just_pressed(aa):
				for p in players:
					if p == null:
						continue
					if p.selected:
						p.use_ability(ability_actions.find(aa))

func is_any_selected():
	var b = false
	for p in players:
		if p == null:
			continue
		if p.selected:
			b=true
			break
	return b

func party_up(p):
	var i = first_null()
	if i == -1 or p in players:
		return -1
	
	players[i] = p
	p.set_selected(true)
	p.set_party(true)
	p.group = i
	
	if hp_panel != null:
		hp_panel.player_set_at(p, i)
	
	if rig != null:
		rig.get_node("sfx/join").play()
	
func kick(p):
	p.ui = null
	var i = players.find(p)
	if i == -1:
		return
	players[i] = null
	p.set_party(false)
	
	if hp_panel!= null:
		hp_panel.get_child(i).clear()
	
	if rig != null:
		rig.get_node("sfx/leave").play()

func print_players():
	var s = ""
	for p in players:
		if p == null:
			s = s + "X,"
			continue
		s = s + p.get_name() + ","
	print(s)

func first_null():
	for i in range(players.size()):
		if players[i] == null:
			return i
	
	return -1

func halt_players():
	halted = true
	for p in players:
		if p == null:
			continue
		p.halt()
func unhalt_players():
	halted = false
	for p in players:
		if p == null:
			continue
		p.unhalt()

func get_players_selected_mid_point():
	var i = 0
	var m = Vector3()
	
	for p in players:
		if p == null:
			continue
		if not p.selected:
			continue
		i+=1
		
		m += p.global_transform.origin
	
	if i !=0:
		m = m/i
	return m

func get_players_mid_point():
	var i = 0
	var m = Vector3()
	
	for p in players:
		if p == null:
			continue
		i+=1
		
		m += p.global_transform.origin
	
	if i !=0:
		m = m/i
	return m

func delayed_delete(obj, t):
	if rig != null:
		var timer = Timer.new()
		timer.wait_time = t
		timer.autostart=true
		timer.connect("timeout", obj, "queue_free")
		
		rig.add_child(timer)