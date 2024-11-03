extends CharacterBody2D

var speed = 100
var player_state

@export var inv: Inv

var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scene/arrow.tscn")
var mouse_location_from_player = null

func _physics_process(delta):
	mouse_location_from_player = get_global_mouse_position() - self.position
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	else:
		player_state = "walking"
	
	velocity = direction * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("1"):
		if bow_equiped:
			bow_equiped = false
		else:
			bow_equiped = true
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equiped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await  get_tree().create_timer(0.4).timeout
		bow_cooldown = true

	play_anim(direction)

func play_anim(dir):
	if !bow_equiped:
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		if player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			if dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			if dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")
	if bow_equiped:
	# Direção Norte (cima)
		if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y < 0:
			$AnimatedSprite2D.play("n-attack")
	# Direção Sul (baixo)
		elif mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y > 0:
			$AnimatedSprite2D.play("s-attack")
	# Direção Leste (direita)
		elif mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x > 0:
			$AnimatedSprite2D.play("e-attack")
	# Direção Oeste (esquerda)
		elif mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x < 0:
			$AnimatedSprite2D.play("w-attack")
	# Direção Nordeste (ne)
		elif mouse_location_from_player.x > 25 and mouse_location_from_player.y < -25:
			$AnimatedSprite2D.play("ne-attack")
	# Direção Sudeste (se)
		elif mouse_location_from_player.x > 25 and mouse_location_from_player.y > 25:
			$AnimatedSprite2D.play("se-attack")
	# Direção Sudoeste (sw)
		elif mouse_location_from_player.x < -25 and mouse_location_from_player.y > 25:
			$AnimatedSprite2D.play("sw-attack")
	# Direção Noroeste (nw)
		elif mouse_location_from_player.x < -25 and mouse_location_from_player.y < -25:
			$AnimatedSprite2D.play("nw-attack")
		
			
func player():
	pass
	
func collect(item):
	if inv:
		inv.insert(item)  # Adiciona o item ao inventário
		print("Item coletado e adicionado ao inventário:", item)
	else:
		print("Erro: 'inv' não foi inicializado. Certifique-se de que o inventário está configurado.")
