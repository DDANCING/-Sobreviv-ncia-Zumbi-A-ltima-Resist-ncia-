extends StaticBody2D

@export var item: InvItem  # O item que será coletado
var Player = null  # Referência ao jogador

# Função chamada quando o jogador entra na área de coleta
func _on_interactable_area_body_entered(body):
	if body.has_method("player"):
		Player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		queue_free()

# Função para coletar o item
func playercollect():
	if Player and item:
		Player.collect(item)
		print("+1 loot")
	else:
		print("Erro: Player ou item não definido.")
