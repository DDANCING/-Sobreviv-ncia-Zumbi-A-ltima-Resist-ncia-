extends Node2D

var state = "car_no_loot"
var player_in_area = false

var loot = preload("res://scene/loot_collectable.tscn")

func _ready():
	if state == "car_no_loot":
		$growth_timer.start()
		
func _process(delta):
	if state == "car_no_loot":
		$AnimatedSprite2D.play("car_no_loot")
	if state == "car_loot":
		$AnimatedSprite2D.play("car_loot")
		if player_in_area:
			if Input.is_action_just_pressed("e"):
				state = "car_no_loot"
				drop_loot()
	



func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true


func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false



func _on_growth_timer_timeout():
	if state == "car_no_loot":
		state = "car_loot"

func drop_loot():
	var loot_instance = loot.instantiate()
	loot_instance.global_position = $Marker2D.global_position
	get_parent().add_child(loot_instance)
	
	await  get_tree().create_timer(3).timeout
	$growth_timer.start()
