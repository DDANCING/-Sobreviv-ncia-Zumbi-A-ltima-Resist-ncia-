extends StaticBody2D



func _ready():
	fallfrombox()
	
func fallfrombox():
	$AnimationPlayer.play("falling_drop")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade")
	print("+1 loot")
	await get_tree().create_timer(0.8).timeout
	queue_free()


