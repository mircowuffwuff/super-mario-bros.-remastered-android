extends PowerUpItem

func _ready() -> void:
	power_up_state = Global.stored_item
	global_position = Global.get_game_viewport_camera_2d().get_screen_center_position() + Vector2(4, -96)
	AudioManager.play_global_sfx("item_appear")
	Global.stored_item = ""
	reset_physics_interpolation()

func _physics_process(delta: float) -> void:
	global_position.y += 48 * delta
