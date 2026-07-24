class_name BlockBouncingDetection
extends Node

@export_enum("Collision", "Hitbox") var detection_type := 0
@export var hitbox: Area2D = null

@export var can_change_direction := false

signal block_bounced(block: Block)

func _physics_process(_delta: float) -> void:
	if detection_type == 0:
		collision_detect()
	else:
		hitbox_detect()

func collision_detect() -> void:
	var collision: KinematicCollision2D = owner.move_and_collide(Vector2.DOWN, true)
	if is_instance_valid(collision):
		if collision.get_collider() is Block:
			if collision.get_collider().bouncing:
				block_bounced.emit(collision.get_collider())
				return

func hitbox_detect() -> void:
	if is_instance_valid(hitbox) == false: return
	hitbox.set_collision_mask_value(3, true)
	for i in hitbox.get_overlapping_bodies():
		if i is Block:
			if i.bouncing:
				block_bounced.emit(i)
				if can_change_direction:
					owner.direction = sign(owner.global_position.x - i.global_position.x)
				return
