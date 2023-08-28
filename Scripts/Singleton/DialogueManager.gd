extends Node
# Classe customizada para diálogos

@onready var Textbox = preload("res://Scenes/Cutscene/textbox.tscn")

var textbox
var texts: Array[String] = []
var nome: String
var page = 0

var is_active = false
var can_advance = false

signal dialogo_acabou

func start_textbox(lines: Array[String], _name: String = ""):
	if is_active:
		return
	texts = lines
	nome = _name
	_show_textbox()
	is_active = true

func _show_textbox():
	textbox = Textbox.instantiate()
	textbox.finished_displaying.connect(_on_textbox_finished_displaying)
	get_tree().root.add_child(textbox)
	textbox.display_text(texts[page], nome)
	can_advance = false

func _on_textbox_finished_displaying():
	can_advance = true

func _unhandled_input(event):
	if (event.is_action_pressed("kSpace") &&
	is_active &&
	can_advance):
		textbox.queue_free()
		page += 1
		if page >= texts.size():
			is_active = false
			page = 0
			dialogo_acabou.emit()
			return
	
		_show_textbox()
		
