extends Node

@export var rotation_joint: Node2D = null
@export var plant: Node2D = null
func _process(_delta: float) -> void:
	if plant != null:
		const OFFSETS = [Vector2.ZERO, Vector2(0, -16), Vector2(-16, 0), Vector2(16, 0)]
		rotation_joint.global_rotation_degrees = [0, 180, 90, -90][plant.pipe_direction]
		rotation_joint.position = OFFSETS[plant.pipe_direction]
