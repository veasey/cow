extends CharacterBody3D

@export var speed := 5.0  # Speed of the cow's movement
@export var turn_speed := 2.0  # Speed of the cow's rotation

var direction := Vector3.ZERO
var animation_player : AnimationPlayer
var rotation_direction := 0.0  # Keeps track of the rotational movement

func _ready():
	# Get the AnimationPlayer node (adjust path if necessary)
	animation_player = $CowModel/AnimationPlayer
	if animation_player == null:
		print("AnimationPlayer node not found!")
	else:
		print("AnimationPlayer node found!")

func _physics_process(delta):
	direction = Vector3.ZERO
	
	# Tank movement control (forward/backward based on cow's facing direction)
	if Input.is_action_pressed("move_forward"):
		direction = -transform.basis.z  # Move in the direction the cow is facing
	if Input.is_action_pressed("move_backward"):
		direction = transform.basis.z  # Move in the opposite direction
	
	# Normalize direction to avoid faster diagonal movement
	direction = direction.normalized()

	# Apply movement based on the speed
	velocity = direction * speed
	move_and_slide()

	# Tank-style rotation control (turning left/right using move_left and move_right)
	rotation_direction = 0.0  # Reset rotational direction

	if Input.is_action_pressed("move_left"):  # Changed to move_left
		rotation_direction = 1  # Rotate left
	if Input.is_action_pressed("move_right"):  # Changed to move_right
		rotation_direction = -1  # Rotate right

	# Rotate the cow
	rotation.y += rotation_direction * turn_speed * delta

	# Play the walking animation when moving forward/backward
	if direction != Vector3.ZERO:
		if animation_player != null:
			if not animation_player.is_playing() or animation_player.current_animation != "walk":
				animation_player.play("walk")
	else:
		if animation_player != null and animation_player.is_playing() and animation_player.current_animation == "walk":
			animation_player.stop()  # Stop the walk animation when stationary
