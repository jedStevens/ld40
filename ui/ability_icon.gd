extends Control

export(Texture) var icon = null

func set_ability(a):
	set_icon(a.icon)
	a.ui = self

func set_icon(t):
	icon = t
	$icon.texture = icon

func set_cd(t):
	$cd.value = t