extends EntityGenerator


const new_vector = Vector2.UP

func activate() -> void:
	active = true
	for i in get_tree().get_nodes_in_group("Players"):
		on_player_entered(i)

func deactivate() -> void:
	active = false
	for i in get_tree().get_nodes_in_group("Players"):
		on_player_exited(i)

func calculate_player_height(player: Player):
	var height = player.physics_params("COLLISION_SIZE")
	if player.crouching:
		height = player.physics_params("CROUCH_COLLISION_SIZE")
	height = height[1]
	return height

func on_player_entered(player: Player) -> void:
	if player.gravity_vector == new_vector:
		return
	player.gravity_vector = new_vector
	player.global_position.y -= calculate_player_height(player)
	player.global_rotation = -player.gravity_vector.angle() + deg_to_rad(90)
	player.get_node("CameraHandler").global_rotation = 0
	player.get_node("CameraHandler").position.x = 0
	player.get_node("CameraHandler").can_diff = false
	player.has_jumped = false
	player.sprite.play("Idle")
	player.reset_physics_interpolation()

func on_player_exited(player: Player) -> void:
	if player.gravity_vector == Vector2.DOWN:
		return
	player.gravity_vector = Vector2.DOWN
	player.global_position.y += calculate_player_height(player)
	player.velocity.y *= 1.1
	player.global_rotation = -player.gravity_vector.angle() + deg_to_rad(90)
	player.get_node("CameraHandler").position.x = 0
	player.has_jumped = false
	player.sprite.play("Idle")
	player.reset_physics_interpolation()
