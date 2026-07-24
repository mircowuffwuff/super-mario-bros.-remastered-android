class_name UpsideDownGravityArea
extends PlayerDetection

var players_inside: Array[Player] = []

@export var polygon: CollisionPolygon2D

@export var enable_low_gravity := true

var low_gravity := false

@export var new_vector := Vector2.UP

func _physics_process(_delta: float) -> void:
	for i in get_tree().get_nodes_in_group("Players"):
		if Geometry2D.is_point_in_polygon(polygon.to_local(i.global_position), polygon.polygon):
			if players_inside.has(i) == false:
				players_inside.append(i)
				on_player_entered(i)
		else:
			if players_inside.has(i):
				players_inside.erase(i)
				on_player_exited(i)

func calculate_player_height(player: Player):
	var player_height = player.physics_params("COLLISION_SIZE")[1]
	if player.crouching:
		player_height = player.physics_params("CROUCH_COLLISION_SIZE")[1]
	return player_height

func on_player_entered(player: Player) -> void:
	low_gravity = player.low_gravity
	player.gravity_vector = new_vector
	player.low_gravity = enable_low_gravity
	player.global_position.y -= calculate_player_height(player)
	player.global_rotation = -player.gravity_vector.angle() + deg_to_rad(90)
	player.get_node("CameraHandler").global_rotation = 0
	player.get_node("CameraHandler").position.x = 0
	player.get_node("CameraHandler").can_diff = false
	player.has_jumped = false
	player.reset_physics_interpolation()

func on_player_exited(player: Player) -> void:
	player.gravity_vector = Vector2.DOWN
	player.low_gravity = low_gravity
	player.global_position.y += calculate_player_height(player)
	player.velocity.y *= 1.1
	player.global_rotation = -player.gravity_vector.angle() + deg_to_rad(90)
	player.get_node("CameraHandler").position.x = 0
	player.has_jumped = false
	player.reset_physics_interpolation()
