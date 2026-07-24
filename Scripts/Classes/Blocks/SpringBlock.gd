extends StaticBody2D

@export var is_super := false

func on_player_entered(player: Player) -> void:
	bounce_player(player)
	player.has_spring_jumped = true
	play_animation()
	AudioManager.play_sfx("spring", global_position)
	if is_super:
		await get_tree().physics_frame
		player.velocity.y *= 1.5

func bounce_player(player: Player) -> void:
	if Global.player_action_pressed("jump", player.player_id):
		player.velocity.y = sign(player.gravity_vector.y) * -player.physics_params("BOUNCE_JUMP_SPEED")
		player.gravity = player.calculate_speed_param("JUMP_GRAVITY")
		player.has_jumped = true
		player.jump_cancelled = false
	else:
		player.velocity.y = sign(player.gravity_vector.y) * -player.physics_params("BOUNCE_SPEED")

func play_animation() -> void:
	$Sprite.play("Bounce")
	await $Sprite.animation_finished
	$Sprite.play("Idle")
