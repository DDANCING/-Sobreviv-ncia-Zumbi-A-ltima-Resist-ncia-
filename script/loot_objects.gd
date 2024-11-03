extends Node2D

var state = "box_no_loot"
var player_in_area = false

# Lista de cenas de loot e seus respectivos itens de inventário (.tres)
var loot_options = [
	preload("res://scene/loot_collectable.tscn"),  # Health kit
	preload("res://scene/loot_collectable2.tscn"), # Maca
	preload("res://scene/loot_collectable3.tscn")  # Gasolina
]

# Lista dos itens de inventário correspondentes (deve ser sincronizada com loot_options)
var loot_items = [
	preload("res://inventory/Items/health_kit.tres"),    # Item de saúde
	preload("res://inventory/Items/apple.tres"),     # Maca
	preload("res://inventory/Items/gas.tres")           # Gasolina
]

var player = null

func _ready():
	if state == "box_no_loot":
		$growth_timer.start()

func _process(delta):
	if state == "box_no_loot":
		$AnimatedSprite2D.play("box_no_loot")
	elif state == "box_loot":
		$AnimatedSprite2D.play("box_loot")
		if player_in_area and Input.is_action_just_pressed("e"):
			state = "box_no_loot"
			drop_loot()

func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body

func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false

func _on_growth_timer_timeout():
	if state == "box_no_loot":
		state = "box_loot"

func drop_loot():
	# Seleciona um loot aleatório da lista
	var random_index = randi() % loot_options.size()
	var random_loot = loot_options[random_index]
	var loot_instance = random_loot.instantiate()
	loot_instance.global_position = $Marker2D.global_position
	get_parent().add_child(loot_instance)
	
	# Associa o item correspondente e coleta
	var loot_item = loot_items[random_index]
	player.collect(loot_item)

	# Mensagem correspondente ao tipo de loot
	match random_index:
		0:
			print("Você coletou um Kit de Saúde!")
		1:
			print("Você coletou uma Maca!")
		2:
			print("Você coletou Gasolina!")
	
	await get_tree().create_timer(3).timeout
	$growth_timer.start()
