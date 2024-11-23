extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()


# Transição entre cenas
func _on_cliffside_transition_pointer_body_entered(body):
	if body.has_method("player"):
		global.transintion_scene = true

func _on_cliffside_transition_pointer_body_exited(body):
	if body.has_method("player"):
		global.transintion_scene = false

# Função de mudança de cena
func change_scene():
	if global.transintion_scene:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scene/cliff_side.tscn")
			if global.has_method("finish_changescene"):
				global.finish_changescene()
			else:
				print("Warning: 'finish_changescene' method is missing in global.gd")


func _on_door_body_entered(body):
	if body.has_method("player"):
		body.set_position($door/Point.global_position)
