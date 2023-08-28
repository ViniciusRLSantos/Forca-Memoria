# Esse script apenas controla a animação e display de informações ao perder
extends Control

@onready var animation = $AnimationPlayer
@onready var pontos_display = $ColorRect/Acertos
var acertos = 0

func _ready():
	animation.play("Suspenso")
	pontos_display.text = ""


func _on_button_pressed():
	queue_free()
	SceneTransition.change_scene("res://Scenes/Sala.tscn")

func mostrar_acertos():
	pontos_display.text = "[center][shake]Acertos: {pontos}".format({"pontos": acertos})

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"Suspenso":
			mostrar_acertos()
