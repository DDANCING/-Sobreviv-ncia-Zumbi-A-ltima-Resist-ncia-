extends Control

@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots_container = $NinePatchRect/GridContainer
@onready var slots: Array = []

var is_open = false

func _ready():
	inv.update.connect(update_Slots)
	if slots_container:
		slots = slots_container.get_children()
		update_Slots()
		close()
	else:
		print("Erro: GridContainer não encontrado!")

func update_Slots():
	for i in range(min(inv.slots.size(), slots.size())):
		if slots[i] and inv.slots[i]:  # Verifica se o slot e o item não são nulos
			slots[i].update(inv.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("i"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
