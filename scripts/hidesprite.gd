extends Sprite2D

# Reference to the parent node (assuming it has the `is_rolling` variable)
@onready var parent = get_parent()

func _process(delta):
	# Check the parent's `is_rolling` and `is_jumping` states
	if parent.is_rolling or parent.is_jumping:
		visible = false  # Hide the Sprite2D when rolling or jumping
	else:
		visible = true   # Show the Sprite2D when not rolling or jumping
