extends Node


var player_current_attack = false

var transintion_scene = false
var current_scene = "world"

var player_exit_cliffside_posx = 0
var player_exit_cliffside_posy = 0
var player_start_posx = 0
var player_start_posy = 0
var player_is_dead = false

func finish_changescene():
	if transintion_scene == true:
		transintion_scene == false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
