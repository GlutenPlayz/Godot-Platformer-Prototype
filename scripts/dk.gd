extends CharacterBody2D

# Movement Variables
@export var speed: float = 250.0
@export var acceleration: float = 15.0
@export var friction: float = 30.0

# Jump Variables
@export var jump_force: float = -350.0
@export var max_fall_speed: float = 600.0
@export var gravity: float = 1000.0
@export var jump_buffer_time: float = 0.15
@export var coyote_time: float = 0.15

# Additional Mechanics
@export var roll_speed: float = 500.0  # Increased roll speed
@export var roll_duration: float = 0.5
var roll_timer: float = 0.0
var is_rolling: bool = false

var jump_buffer_timer: float = 0.0
var coyote_timer: float = 0.0
var is_jumping: bool = false
var air_momentum: float = 0.0

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump_buffer(delta)
	handle_movement(delta)
	handle_roll(delta)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
	else:
		coyote_timer = coyote_time  # Reset coyote timer when on the ground
		is_jumping = false
		# Removed: air_momentum = 0.0  # Reset momentum on landing

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
	air_momentum = velocity.x  # Preserve momentum at jump start

func handle_movement(delta):
	if is_rolling:
		return
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, friction)
		air_momentum = velocity.x  # Store the ground momentum
	else:
		# In air, allow some control but maintain momentum
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration * 0.5)
		air_momentum = velocity.x  # Continuously update air momentum

	# Variable Jump Height
	if is_jumping and Input.is_action_just_released("jump") and velocity.y < jump_force / 2:
		velocity.y *= 0.5

func handle_roll(delta):
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false
		return
	
	if Input.is_action_just_pressed("roll") and is_on_floor():
		is_rolling = true
		roll_timer = roll_duration
		velocity.x = roll_speed * Input.get_axis("move_left", "move_right")

func _process(delta):
	if Input.is_action_just_pressed("respawn"):
		respawn()

func respawn():
	# Reset player position
	global_position = initial_position  # You need to set this when the game starts

	# Reset player state
	velocity = Vector2.ZERO
	is_jumping = false
	is_rolling = false
	
	# Reset any other necessary variables
	
	# Optionally, you can reload the entire current scene
	# get_tree().reload_current_scene()

var initial_position: Vector2

func _ready():
	initial_position = global_position
