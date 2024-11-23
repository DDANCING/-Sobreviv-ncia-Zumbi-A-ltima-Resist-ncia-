extends CharacterBody2D

var speed = 20 # Velocidade normal
var wander_speed = 10 # Velocidade ao vagar
var health = 1000
var player_inattack_zone = false

var dead = false
var player_in_area = false
var player

@onready var bone = $bone_collectable
@export var itemRes: InvItem

# Variáveis para movimentação aleatória
var random_direction = Vector2.ZERO
var random_timer = 0.0
var change_direction_time = 2.0 # Tempo em segundos para mudar a direção aleatória
@onready var audio_player = $audio_player

func _ready():
	dead = false
	set_random_direction() # Define a direção inicial aleatória

func _physics_process(delta):
	deal_with_damage()
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		
		if player_in_area:
			# Move o personagem em direção ao jogador
			var direction = (player.position - position).normalized() # Normaliza a direção
			position += direction * speed * delta
			update_animation(direction)
		else:
			# Movimentação aleatória quando não há jogador
			random_timer -= delta
			if random_timer <= 0:
				set_random_direction() # Muda a direção aleatória
				random_timer = change_direction_time # Reinicia o temporizador

			position += random_direction * wander_speed * delta # Move na direção aleatória
			update_animation(random_direction)
			
		move_and_slide()
	else:
		$detection_area/CollisionShape2D.disabled = true

func _on_detection_area_body_entered(body):
	if body.has_method("player"): # Verifica se o corpo é um jogador
		player_in_area = true
		player = body
		audio_player.stream = preload("res://art/zombie-15965.mp3")
		audio_player.play()

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

func _on_hitbox_area_entered(area):
	if !dead and area.has_method("arrow_deal_damage"):
		take_damage(50)

func take_damage(damage):
	if dead:
		return
	health -= damage
	if health <= 0:
		death()
	else:
		play_damage_animation()

func play_damage_animation():
	if random_direction.y < 0:
		$AnimatedSprite2D.play("n-damage")
	elif random_direction.y > 0:
		$AnimatedSprite2D.play("s-damage")
	else:
		$AnimatedSprite2D.play("w-damage")

func death():
	dead = true
	$AnimatedSprite2D.play("s-death")
	await get_tree().create_timer(0.6).timeout
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	queue_free()
	
func _on_hitbox_body_entered(body):
	if !dead and body.has_method("player"):
		player_inattack_zone = true

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if !dead and player_inattack_zone and global.player_current_attack:
		take_damage(20)
		print("zombie health = ", health)
		if health <= 0:
			queue_free()
