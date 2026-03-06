extends AnimatedSprite2D

# Reference to the parent node (assuming it has the `is_rolling`, `is_jumping`, and `is_moving` variables)
@onready var parent = get_parent()

func _ready():
	play("idle_tails")  # Start with the idle animation

func _process(delta):
	# Check the parent's states and play the appropriate animation
	if parent.is_rolling or parent.is_jumping:
		play("ball")  # Play the "ball" animation when rolling or jumping
		offset.x = 0  # Reset offset for ball animation
	elif parent.is_moving:
		play("jog")  # Play the "jog" animation when moving
		offset.x = -8  # Apply -8 offset on x-axis for jog animation
	else:
		play("idle_tails")  # Switch back to idle when not rolling, jumping, or moving
		offset.x = 0  # Reset offset for idle animation

	# Flip the sprite based on the character's direction
	if parent.velocity.x < 0:
		flip_h = true  # Flip horizontally when moving left
	elif parent.velocity.x > 0:
		flip_h = false  # Don't flip when moving right

	# If rolling, use the roll direction to determine flipping
	if parent.is_rolling:
		flip_h = parent.roll_direction < 0
