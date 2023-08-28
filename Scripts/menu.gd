extends Control
# Menu

func _on_play_pressed():
	SceneTransition.change_scene("res://Scenes/sala_de_aula.tscn")


func _on_fechar_pressed():
	get_tree().quit()
