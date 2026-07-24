extends Block

func on_area_entered(area: Area2D) -> void:
	if area.owner is Player:
		var player: Player = area.owner
		if player.velocity.y < 0 and player.global_position.y > $Hitbox.global_position.y and abs(player.global_position.x - global_position.x) < 8:
			player_block_hit.emit(area.owner)
			block_hit.emit()
			player.velocity.y = 0
			player.bump_ceiling()
			$Collision.set_deferred("disabled", false)
			can_hit = true
