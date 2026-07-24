class_name Crate
extends CharacterBody2D

@export var item: PackedScene = null

const CRATE_DESTRUCTION_PARTICLES = preload("uid://cq1cyk2gwwjis")


func _physics_process(delta: float) -> void:
	var last_velocity = velocity
	handle_movement(delta)
	var collision_enabled = velocity.length() < 10 or is_on_floor()
	$Collision.set_deferred("one_way_collision", collision_enabled == false)
	if is_on_floor() or is_on_wall() or is_on_ceiling():
		if last_velocity.length() >= 500:
			destroy()


func handle_movement(delta: float) -> void:
	if $WaterHitbox.get_overlapping_areas().is_empty() == false or $WaterHitbox.get_overlapping_bodies().is_empty() == false:
		velocity.y = clamp(velocity.y, -280, Global.entity_max_fall_speed / 2)
		velocity.y -= 5
		velocity.x = lerpf(velocity.x, 0, delta)
	else:
		apply_gravity(delta)
	if is_on_floor():
		var friction = 5
		if $RayCast2D.is_colliding():
			friction = 1
		velocity.x = lerpf(velocity.x, 0, delta * friction)
	for i in $PlayerDetection.get_overlapping_areas():
		if i.owner is Player and i.owner.global_position.y < global_position.y:
			if i.owner.power_state.hitbox_size == "Small":
				velocity.y += 4
			else:
				velocity.y += 5
	move_and_slide()

func apply_gravity(delta: float) -> void:
	velocity.y += (Global.entity_gravity / delta) * delta
	velocity.y = clamp(velocity.y, -INF, Global.entity_max_fall_speed * 2)

func splash() -> void:
	velocity.y = clamp(velocity.y / 1.25, 20, INF)

func destroy(dispense_item := true) -> void:
	Global.score += 50
	AudioManager.play_sfx("block_break", global_position)
	summon_particles()
	if item != null:
		summon_item(not dispense_item)
	queue_free()
	
const SMOKE_PARTICLE = preload("uid://d08nv4qtfouv1")

func summon_particles() -> void:
	var particle = CRATE_DESTRUCTION_PARTICLES.instantiate()
	particle.global_position = global_position
	add_sibling(particle)
	var smoke = SMOKE_PARTICLE.instantiate()
	smoke.global_position = global_position
	add_sibling(smoke)

func summon_item(kill := false) -> void:
	var node = item.instantiate()
	node.global_position = global_position - Vector2(0, 1)
	var direction = [-1, 1].pick_random()
	node.set("velocity", Vector2(80 * direction, -150))
	node.set("direction", direction)
	add_sibling(node)
	if kill and node is Enemy:
		node.die()


func on_player_entered(player: Player) -> void:
	if player.global_position.y > global_position.y and player.is_on_floor() == false and player.velocity.y < 0:
		player.bump_ceiling()
		destroy()
		return
	if global_position.y < player.global_position.y and is_on_floor() == false and player.is_on_floor():
		velocity = Vector2(50 * -sign(player.global_position.x - global_position.x), -100)
