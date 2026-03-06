extends CharacterBody2D

# Movement Variables
@export var speed: float = 200.0
@export var acceleration: float = 10.0
@export var friction: float = 20.0

# Jump Variables
@export var jump_force: float = -300.0
@export var max_fall_speed: float = 500.0
@export var gravity: float = 900.0
@export var jump_buffer_time: float = 0.1
@export var coyote_time: float = 0.1

var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0
var is_jumping: bool = false

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump_buffer(delta)
	handle_movement(delta)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	else:
		coyote_timer = coyote_time  # Reset coyote timer when on the ground
		is_jumping = false

func handle_jump_buffer(delta):
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	if coyote_timer > 0:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	
	if (jump_buffer_timer > 0 and coyote_timer > 0):
		jump()
		jump_buffer_timer = 0

func jump():
	velocity.y = jump_force
	is_jumping = true
	coyote_timer = 0

func handle_movement(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0
	
	# Variable Jump Height
	if is_jumping and Input.is_action_just_released("jump") and velocity.y < jump_force / 2:
		velocity.y *= 0.5
