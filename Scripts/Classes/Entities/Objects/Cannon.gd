extends Node2D

@export var item: PackedScene = preload("uid://bumvqjhs2xxka")

@export_range(0, 8, 1) var head_angle := 0
@export_range(0, 4, 1) var stand_angle := 0

var amount := 0

func start() -> void:
	if $SignalExposer.total_inputs <= 0:
		$Timer.start()

func shoot() -> void:
	if (amount >= 3 or $Head/Raycast.is_colliding()) and $SignalExposer.total_inputs <= 0:
		return
	var node = item.instantiate()
	var direction_vector = [Vector2.UP * 2, Vector2(1, -1), Vector2.RIGHT, Vector2(1, 1), Vector2.DOWN, Vector2(-1, 1), Vector2.LEFT, Vector2(-1, -1), Vector2.UP][head_angle]
	node.set("direction_vector", direction_vector)
	node.set("velocity", 100 * direction_vector)
	if direction_vector.x != 0:
		node.set("direction", sign(direction_vector.x))
	node.global_position = global_position + Vector2(0, 7)
	node.tree_exited.connect(func(): amount -= 1)
	amount += 1
	AudioManager.play_sfx("cannon", global_position)
	add_sibling(node)
	node.set_meta("no_persist", true)
	if node is CharacterBody2D:
		var old_z = node.z_index
		node.z_index = -1
		node.add_collision_exception_with($StaticBody2D)
		await get_tree().create_timer(0.1, false).timeout
		if is_instance_valid(node):
			node.remove_collision_exception_with($StaticBody2D)
			node.z_index = old_z
