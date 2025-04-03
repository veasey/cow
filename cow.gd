extends CharacterBody3D

@export var speed: float = 2.5
@export var turn_speed: float = 1.0
@onready var animation_player = get_node("CowModel/AnimationPlayer")
@onready var idle_timer = Timer.new()

var direction = Vector3.ZERO
var rotation_direction = 0.0

func _ready():
	add_child(idle_timer)
	idle_timer.one_shot = false
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	_reset_idle_timer()

func _physics_process(delta):
	direction = Vector3.ZERO
	
	# Tank movement control (forward/backward based on cow's facing direction)
	if Input.is_action_pressed("move_forward"):
		direction = -transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction = transform.basis.z
		
	if Input.is_action_pressed("jump"):
		animation_player.play("jump")
		move_and_slide
		return;
	
	# Normalize direction to avoid faster diagonal movement
	direction = direction.normalized()
	
	# Apply movement based on the speed
	velocity = direction * speed
	move_and_slide()

	# Tank-style rotation control
	rotation_direction = 0.0

	if Input.is_action_pressed("move_left"):
		rotation_direction = 1
	if Input.is_action_pressed("move_right"):
		rotation_direction = -1

	rotation.y += rotation_direction * turn_speed * delta

	# Play animations
	if direction != Vector3.ZERO:
		_reset_idle_timer()  # Reset idle timer if moving
		if animation_player != null:
			if not animation_player.is_playing() or animation_player.current_animation != "walk":
				animation_player.play("walk")
	else:
		if animation_player != null and animation_player.is_playing() and animation_player.current_animation == "walk":
			animation_player.stop()

func _on_idle_timer_timeout():
	if direction == Vector3.ZERO and rotation_direction == 0.0:
		animation_player.play("iddle")  # Replace with your idle animation name
	_reset_idle_timer()

func _reset_idle_timer():
	idle_timer.wait_time = randf_range(2.0, 5.0)
	idle_timer.start()
