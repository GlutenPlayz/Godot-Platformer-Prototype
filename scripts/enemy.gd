extends CharacterBody2D

var speed = 100
var player = null
var is_player_detected = false

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		print("Player found:", player)
	else:
		print("Error: No player found in the 'player' group.")

func _physics_process(delta):
	if is_player_detected and player:
		print("Player detected and assigned. Moving towards player.")
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		print("Velocity:", velocity)
		move_and_slide()
	else:
		print("Player not detected or not assigned.")

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		is_player_detected = true
		print("Player detected")

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		is_player_detected = false
		print("Player left detection area")
