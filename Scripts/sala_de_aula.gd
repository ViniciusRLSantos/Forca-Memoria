extends Node3D

# var animations = $TeacherAnimation.get_
@onready var ForcaGame = preload("res://Scenes/forca.tscn")
@onready var LoseGame = preload("res://Scenes/lose_screen.tscn")
@onready var timer = $Timer
var palavras_corretas = 0
var forca

func _ready():
	# pass
	$TeacherAnimation.play("Teacher Idle")
	# print(animations)

func _on_teacher_animation_animation_finished(anim_name):
	match anim_name:
		"Teacher Idle":
			# $TeacherAnimation.stop(true)
			DialogueManager.start_textbox([
				"Nossa que sono... Não consegui dormir ontem",
				"Não sei se vou aguentar ficar acordado por muito tempo..."
			], "Aluno")
			DialogueManager.dialogo_acabou.connect(_on_aluno_dialogue_finished)
			# $TeacherAnimation.play("Camera Tilt")
		"Camera Tilt":
			$TeacherAnimation.stop(true)
			$TeacherAnimation.play("Camera Tilt Up")
		"Camera Tilt Up":
			$TeacherAnimation.stop(true)
			$TeacherAnimation.play("Teacher Brotar")
		"Teacher Brotar":
			$TeacherAnimation.stop(true)
			DialogueManager.dialogo_acabou.connect(_on_teacher_dialogue_finished)
			DialogueManager.start_textbox([
				"COMO OUSA DORMIR NA MINHA AULA!",
				"AAAAH JÁ SEI",
				"VOCÊ ACHA QUE JÁ SABE DE TUDO NÃO É!!!!",
				"QUE TAL ASSIM...",
				"VOCÊ TEM 8 CHANCES PARA ACERTAR MINHAS PERGUNTAS. SE ERRAR MAIS QUE ISSO VOCÊ SERÁ SUSPENSO!!!",
				"HAHAHAHA PUNIÇÃO MAIS JUSTA QUE ESSA NÃO TEM."
			], "Prof. Chatonilson")
			

func _on_aluno_dialogue_finished():
	$TeacherAnimation.play("Camera Tilt")
	DialogueManager.dialogo_acabou.disconnect(_on_aluno_dialogue_finished)

# Inicia o jogo da forca e conecta os sinais de vitória e derrota
func _on_teacher_dialogue_finished():
	forca = ForcaGame.instantiate()
	get_tree().root.add_child(forca)
	forca.vitoria.connect(_on_game_win)
	forca.derrota.connect(_on_game_lose)
	$Musica.play()
	DialogueManager.dialogo_acabou.disconnect(_on_teacher_dialogue_finished)

# Executado ao receber um sinal de vitória do jogo da forca
func _on_game_win():
	forca.queue_free()
	DialogueManager.start_textbox([
		"..........",
		"não pode ser...",
		"eu sou o professor... e você é só um mero aluno...",
		"como pode...."
	], "Prof. Chatonilson")
	DialogueManager.dialogo_acabou.connect(_on_win_dialogue_finished)

func _on_win_dialogue_finished():
	$Musica.stop()
	# forca.queue_free()
	SceneTransition.change_scene("res://Scenes/Sala.tscn")

# Executado ao receber um sinal de derrota do jogo da forca
func _on_game_lose():
	$Musica.stop()
	palavras_corretas = forca.pontos
	forca.queue_free()
	timer.start()

func _on_timer_timeout():
	var tela_derrota = LoseGame.instantiate()
	tela_derrota.acertos = palavras_corretas
	get_tree().root.add_child(tela_derrota)
