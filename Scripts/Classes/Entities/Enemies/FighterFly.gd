extends Enemy

const BUZZY_BEETLE = preload("res://Scenes/Prefabs/Entities/Enemies/BuzzyBeetle.tscn")

var jump_meter := 0.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_meter += delta
	
	$Sprite.play(["Fly", "Idle"][int(is_on_floor())])
	
	if jump_meter >= 0.5:
		$BasicEnemyMovement.bounce_on_land = true
		$BasicEnemyMovement.move_speed = 30
		jump_meter = 0
	elif is_on_floor():
		$BasicEnemyMovement.bounce_on_land = false
		$BasicEnemyMovement.move_speed = 0

func stomped_on(player: Player) -> void:
	AudioManager.play_sfx("enemy_stomp", global_position)
	$BasicEnemyMovement.can_move = false
	Global.combo_amount += 1
	player.enemy_bounce_off()
	$Sprite.play("Stomped")
	$Hitbox.queue_free()
	await get_tree().create_timer(0.5, false).timeout
	queue_free()
