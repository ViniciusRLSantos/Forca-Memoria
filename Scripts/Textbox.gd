extends Control
# Caixa de Texto


@onready var text_display = $Panel/Text # Display do texto
@onready var name_display = $Panel/Name # Display do nome
@onready var fim_display = $Panel/Fim # Texto que aparecerá ao completar a caixa de texto
@onready var timer = $LetterDisplayTimer

var text = "" # Texto padrão
var character = 0.0; # Variável responsável pelos caracteres visíveis

const TEXT_SPEED = 0.05 # Velocidade do texto

# Sinal que será emitido ao finalizar o texto
signal finished_displaying()

func _ready():
	fim_display.visible = false

func _process(delta):
	text_display.visible_characters = character

# Define o que será o texto e o nome (valor padrão = vazio)
func display_text(texto: String, name: String = ""):
	text = texto
	name_display.text = "[center][wave]" + name
	text_display.text = "[center]" + texto

# Se o usuário apertar a barra de espaço antes de terminar o texto, revelará todo o texto
func _unhandled_input(event):
	if event.is_action_pressed("kSpace"):
		if character < text.length():
			character = text.length()

# Método que será executado cada vez que o timer é zerado
func _on_letter_display_timer_timeout():
	if character < text.length():
		$Fala.play()
		character += 1.0
		timer.start(TEXT_SPEED)
	else:
		fim_display.visible = true
		finished_displaying.emit()
		return
