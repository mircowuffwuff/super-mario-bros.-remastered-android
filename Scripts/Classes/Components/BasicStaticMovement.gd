class_name BasicStaticMovement
extends Node

@export var auto_call := true

func _physics_process(delta: float) -> void:
	if auto_call:
		handle_movement(delta)

func handle_movement(delta: float) -> void:
	apply_gravity(delta)
	if owner.is_on_floor():
		owner.velocity.x = lerpf(owner.velocity.x, 0, delta * 20)
	owner.move_and_slide()

func apply_gravity(delta: float) -> void:
	owner.velocity.y += (Global.entity_gravity / delta) * delta
	owner.velocity.y = clamp(owner.velocity.y, -INF, Global.entity_max_fall_speed)
