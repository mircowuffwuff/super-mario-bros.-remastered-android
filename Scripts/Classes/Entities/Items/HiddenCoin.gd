extends Node2D

@export var coin: Node2D = null

func spawn_coin() -> void:
	coin.get_node("PSwitcher").enabled = true
	coin.show()
	coin.reparent(get_parent())
	coin.global_position = global_position
	coin.get_node("PSwitcher")._ready.call_deferred()
	queue_free()


func on_player_entered(_player: Player) -> void:
	hide()
	await get_tree().create_timer(0.25, false).timeout
	AudioManager.play_sfx("hidden_coin", global_position)
	spawn_coin()
