# ESTE NÓDULO SÓ SERVE PRA ROTACIONAR A CÂMERA RELATIVO A ESSE PONTO
extends Node3D

@export var rotation_speed = 10

func _process(delta):
	rotation.y += deg_to_rad(rotation_speed * delta)
	rotation.y = wrapf(rotation.y, deg_to_rad(0.0), deg_to_rad(360.0))
