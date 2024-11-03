extends CharacterBody2D

var speed = 50 # Velocidade normal
var wander_speed = 25 # Velocidade ao vagar
var health = 100
var damage

var dead = false
var player_in_area = false
var player

# Variáveis para movimentação aleatória
var random_direction = Vector2.ZERO
var random_timer = 0.0
var change_direction_time = 2.0 # Tempo em segundos para mudar a direção aleatória

func _ready():
	dead = false
	set_random_direction() # Define a direção inicial aleatória

func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		
		if player_in_area:
			# Move o personagem em direção ao jogador
			var direction = (player.position - position).normalized() # Normaliza a direção
			
			# Atualiza a posição com base na direção e na velocidade
			position += direction * speed * delta
			
			# Atualiza a animação com base na direção do jogador
			update_animation(direction)
		else:
			# Movimentação aleatória quando não há jogador
			random_timer -= delta
			if random_timer <= 0:
				set_random_direction() # Muda a direção aleatória
				random_timer = change_direction_time # Reinicia o temporizador

			position += random_direction * wander_speed * delta # Move na direção aleatória
			# Atualiza a animação para a movimentação aleatória
			update_animation(random_direction)

	else:
		$detection_area/CollisionShape2D.disabled = true

func _on_detection_area_body_entered(body):
	if body.has_method("player"): # Verifica se o corpo é um jogador
		player_in_area = true
		player = body

func _on_detection_area_body_exited(body):
	if body.has_method("player"): # Verifica se o corpo é um jogador
		player_in_area = false

func set_random_direction():
	# Gera uma direção aleatória
	var angle = randf_range(0, 2 * PI) # Gera um ângulo aleatório
	random_direction = Vector2(cos(angle), sin(angle)).normalized() # Cria um vetor unitário na direção do ângulo

func update_animation(dir: Vector2):
	if dir.length() > 0: 
		if abs(dir.x) > abs(dir.y): 
			if dir.x > 0:
				$AnimatedSprite2D.scale.x = -1 
				$AnimatedSprite2D.play("w-walking") 
			else: 
				$AnimatedSprite2D.scale.x = 1 
				$AnimatedSprite2D.play("w-walking")
		else: 
			if dir.y < 0: 
				$AnimatedSprite2D.scale.x = 1 
				$AnimatedSprite2D.play("n-walking")
			else: 
				$AnimatedSprite2D.scale.x = 1 
				$AnimatedSprite2D.play("s-walking")
	else:
		$AnimatedSprite2D.stop() 

