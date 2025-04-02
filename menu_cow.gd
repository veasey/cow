extends Node3D

@export var rotation_speed: float = 1.0

func _process(delta):
	rotation.y += rotation_speed * delta
