extends "res://characters/npc_base/ai_node.gd"

export(float) var lifetime = 5.0

func on_start():
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.autostart = true
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "fizzle")
	print("Go go fire demon")

func exec_ai(delta):
	pass

func fizzle():
	ai_obj.get_node("anim").play("death")
	ai_obj.get_node("anim").connect("animation_finished", self, "kill_ai_obj")
	print("Die fire demon, die")

func kill_ai_obj(anim):
	ai_obj.call_deferred("queue_free")
	print("k but really die")