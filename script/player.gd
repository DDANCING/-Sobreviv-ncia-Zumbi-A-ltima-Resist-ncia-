extends CharacterBody2D

# Variáveis de movimento e stamina
var speed = 50
var sprint_speed = 100
var player_state
var stamina = 10.0
var stamina_recovery_rate = 1.0  
var is_sprinting = false

# Variáveis de inventário e equipamento
@export var inv: Inv
var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scene/arrow.tscn")
var mouse_location_from_player = null

# Referência da barra de stamina
@onready var stamina_bar = $Stamina_bar/ProgressBar  # Atualize o caminho se necessário

func _physics_process(delta):
	# Calcular posição do mouse
	mouse_location_from_player = get_global_mouse_position() - self.position
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# Definir estado do jogador
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	else:
		player_state = "walking"
	
	# Controle de velocidade
	var current_speed = speed

	# Sprint e controle de stamina
	if Input.is_action_pressed("shift") and !bow_equiped and stamina > 0:
		is_sprinting = true
		stamina -= delta
		current_speed = sprint_speed
	else:
		is_sprinting = false
		if stamina < 10.0:
			stamina += stamina_recovery_rate * delta  # Recuperar stamina
	
	# Limitar stamina entre 0 e 10
	stamina = clamp(stamina, 0, 10)
	
	# Reduzir velocidade ao equipar arco
	if bow_equiped:
		current_speed /= 2  # Reduz a velocidade ao segurar o arco
	
	# Aplicar penalidade de velocidade ao estar com stamina baixa
	if stamina <= 0:
		current_speed = speed / 2  # Velocidade reduzida ao mínimo
	elif stamina < 3:
		current_speed = speed * 0.75  # Velocidade parcialmente reduzida até stamina >= 3
	
	# Atualizar a barra de stamina
	stamina_bar.value = stamina  # Sincroniza o valor da barra com a stamina atual
	
	# Movimento do jogador
	velocity = direction * current_speed
	move_and_slide()
	
	# Alternar arco equipado/desequipado
	if Input.is_action_just_pressed("1"):
		bow_equiped = not bow_equiped
	
	# Direção do marcador para apontar para o mouse
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	# Disparo de flecha com arco equipado e cooldown
	if Input.is_action_just_pressed("left_mouse") and bow_equiped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true

	# Jogar animação correspondente
	play_anim(direction)

func play_anim(dir):
	if !bow_equiped:
		if player_state == "idle":
			$AnimatedSprite2D.play("idle")
		elif player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n-walk")
			elif dir.x == 1:
				$AnimatedSprite2D.play("e-walk")
			elif dir.y == 1:
				$AnimatedSprite2D.play("s-walk")
			elif dir.x == -1:
				$AnimatedSprite2D.play("w-walk")
			elif dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("ne-walk")
			elif dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("se-walk")
			elif dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("sw-walk")
			elif dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("nw-walk")
	elif bow_equiped:
		if mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y < 0:
			$AnimatedSprite2D.play("n-attack")
		elif mouse_location_from_player.x >= -25 and mouse_location_from_player.x <= 25 and mouse_location_from_player.y > 0:
			$AnimatedSprite2D.play("s-attack")
		elif mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x > 0:
			$AnimatedSprite2D.play("e-attack")
		elif mouse_location_from_player.y >= -25 and mouse_location_from_player.y <= 25 and mouse_location_from_player.x < 0:
			$AnimatedSprite2D.play("w-attack")
		elif mouse_location_from_player.x > 25 and mouse_location_from_player.y < -25:
			$AnimatedSprite2D.play("ne-attack")
		elif mouse_location_from_player.x > 25 and mouse_location_from_player.y > 25:
			$AnimatedSprite2D.play("se-attack")
		elif mouse_location_from_player.x < -25 and mouse_location_from_player.y > 25:
			$AnimatedSprite2D.play("sw-attack")
		elif mouse_location_from_player.x < -25 and mouse_location_from_player.y < -25:
			$AnimatedSprite2D.play("nw-attack")

func player():
	pass

func collect(item):
	if inv:
		inv.insert(item)
		print("Item coletado e adicionado ao inventário:", item)
	else:
		print("Erro: 'inv' não foi inicializado. Certifique-se de que o inventário está configurado.")
