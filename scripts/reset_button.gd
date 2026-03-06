extends Node

# Reference to the parent CharacterBody2D
var character_body: CharacterBody2D

# The spawn position where the character will respawn
var spawn_position: Vector2

# A flag to indicate if the player should respawn
var should_respawn: bool = false

func _ready():
	# Automatically assign the parent as the CharacterBody2D
	character_body = get_parent() as CharacterBody2D

	# Check if the parent is a CharacterBody2D
	if character_body:
		# Save the character's initial position as the spawn position
		spawn_position = character_body.global_position
	else:
		# Print an error if the parent is not a CharacterBody2D
		print("Error: Parent is not a CharacterBody2D")

func _process(delta: float) -> void:
	# Check if the "respawn" action is pressed
	if Input.is_action_just_pressed("respawn"):
		should_respawn = true

func _physics_process(delta: float) -> void:
	if should_respawn:
		# Reset the character's position to the spawn position
		character_body.global_position = spawn_position
		# Reset the character's momentum (velocity)
		character_body.velocity = Vector2.ZERO
		# Reset the respawn flag
		should_respawn = false
