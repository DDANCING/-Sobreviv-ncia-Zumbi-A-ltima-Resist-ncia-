extends Control

@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots_container = $NinePatchRect/GridContainer
@onready var slots: Array = []

var is_open = false

func _ready():
	# Conectar atualização de slots
	inv.update.connect(update_slots)
	
	if slots_container:
		slots = slots_container.get_children()
		update_slots()
		close()
	else:
		print("Erro: GridContainer não encontrado!")

# Atualizar os slots no inventário
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		if slots[i] and inv.slots[i]:  # Verifica se o slot e o item não são nulos
			slots[i].update(inv.slots[i])

# Gerenciar abertura e fechamento do inventário
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

# Detectar clique direito no slot
func _on_slot_right_click(slot_index):
	var item = inv.slots[slot_index]
	if item:
		inv.on_item_right_click(item)

# Detectar início do arrastar no slot
func _on_slot_drag_start(slot_index):
	var item = inv.slots[slot_index]
	if item:
		# Inicia o arrasto do item
		set_drag_preview(item.icon)  # Assuma que o item tem uma propriedade `icon`
		return item

# Detectar término do arrastar no slot
func _on_slot_drag_end(from_slot_index, to_slot_index):
	var item_a = inv.slots[from_slot_index]
	var item_b = inv.slots[to_slot_index]
	
	if item_a and item_b:
		inv.combine_items(item_a, item_b)
		update_slots()  # Atualiza os slots após a combinação
