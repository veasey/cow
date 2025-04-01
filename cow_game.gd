extends Node3D

@onready var audio_player = $AudioStreamPlayer3D  # Reference to AudioStreamPlayer3D under Cow

var moo_sounds = []  # Array to store sound files

func _ready():
	moo_sounds = [
		preload("res://Sounds/Player/moo1.ogg"),
		preload("res://Sounds/Player/moo2.ogg"),
		preload("res://Sounds/Player/moo3.ogg"),
		preload("res://Sounds/Player/moo4.ogg"),
		preload("res://Sounds/Player/moo5.ogg"),
		preload("res://Sounds/Player/moo6.ogg")
	]
	
	SimpleGrass.set_interactive(true)

func _input(event):
	
	# Spacebar = MOO!
	if event.is_action_pressed("moo"):
		play_moo()

func play_moo():
	var random_sound = moo_sounds[randi() % moo_sounds.size()]  # Pick a random sound
	audio_player.stream = random_sound  # Assign it to the player
	audio_player.play()  # Play the sound
