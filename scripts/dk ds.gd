extends CharacterBody2D

# Player movement variables
@export var max_speed: float = 300.0  # Base movement speed
@export var acceleration: float = 2000.0  # Faster acceleration
@export var friction: float = 2000.0  # Stronger friction for quick stops
@export var air_acceleration: float = 1000.0  # Less control in the air
@export var jump_force: float = -350.0
@export var gravity: float = 1000.0
@export var max_fall_speed: float = 600.0
@export var coyote_time: float = 0.15  # Time in seconds to allow jumping after leaving a platform
@export var jump_cut_multiplier: float = 0.5  # Reduce jump height when releasing the jump button early

# Rolling variables
@export var roll_speed: float = 500.0  # Speed boost when rolling
@export var roll_duration: float = 0.5  # Duration of the roll
var roll_timer: float = 0.0
var is_rolling: bool = false
var roll_direction: int = 1  # 1 for right, -1 for left

# Internal variables
var is_jumping: bool = false
var is_moving: bool = false  # New variable to track movement state
var coyote_timer: float = 0.0
var jump_released: bool = false

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

	# Handle horizontal movement
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction != 0 and not is_rolling:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * max_speed, air_acceleration * delta)
	else:
		if is_on_floor() and not is_rolling:
			velocity.x = move_toward(velocity.x, 0, friction * delta)
		elif not is_rolling:
			velocity.x = move_toward(velocity.x, 0, air_acceleration * delta)

	# Update is_moving state
	is_moving = direction != 0 and not is_rolling  # Player is moving if there's input and not rolling

	# Handle jumping
	if (is_on_floor() or coyote_timer > 0) and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
		is_jumping = true
		jump_released = false
		coyote_timer = 0.0  # Reset coyote time after jumping

	# Variable jump height (cut jump short if button is released)
	if is_jumping and Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier
		jump_released = true

	# Handle rolling
	handle_roll(delta)

	# Apply movement with slope handling
	move_and_slide()

	# Adjust velocity for slopes
	if is_on_floor():
		var floor_normal = get_floor_normal()
		if floor_normal != Vector2.UP:
			# Adjust velocity to move along the slope
			velocity = velocity.slide(floor_normal)

	# Coyote time logic
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Reset jump state when landing
	if is_on_floor() and is_jumping:
		is_jumping = false

# Handle rolling mechanics
func handle_roll(delta: float) -> void:
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false
		else:
			velocity.x = roll_speed * roll_direction  # Maintain rolling speed
		return

	if is_on_floor() and Input.is_action_just_pressed("roll"):
		is_rolling = true
		roll_timer = roll_duration
		roll_direction = 1 if Input.is_action_pressed("move_right") else -1  # Set roll direction
		velocity.x = roll_speed * roll_direction  # Apply rolling speed
