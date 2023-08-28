extends Node3D

@onready var animation =$"../BrainAnimation"

func _ready():
	animation.play("brain_sine_wave")
