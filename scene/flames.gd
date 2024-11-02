extends Node2D

# Chama quando o node entra na árvore da cena pela primeira vez
func _ready():
	# Acessa o AnimatedSprite2D e inicia a animação
	$AnimatedSprite2D.play()

# Chama a cada frame. 'delta' é o tempo decorrido desde o frame anterior
func _process(delta):
	pass

