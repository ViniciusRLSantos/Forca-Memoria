extends CanvasLayer
# Classe customizada para transição entre salas/fases

func change_scene(target: String):
	$AnimationPlayer.play("DISSOLVE")
	await $AnimationPlayer.animation_finished # _on_animation_player_animation_finished("DISSOLVE")
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("DISSOLVE")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "DISSOLVE":
		return
