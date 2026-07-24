extends Area2D

static var meter := 0.0

const LEAPING_CHEEP_CHEEP = preload("res://Scenes/Prefabs/Entities/Enemies/LeapingCheepCheep.tscn")

func _physics_process(delta: float) -> void:
	if get_overlapping_areas().any(func(area: Area2D): return area.owner is Player) != false:
		meter += 1 * delta
	if meter >= 1:
		meter = 0
		spawn_cheep_cheep()

func spawn_cheep_cheep() -> void:
	var node = LEAPING_CHEEP_CHEEP.instantiate()
	node.global_position.x = Global.get_game_viewport_camera_2d().get_screen_center_position().x + [ -32 ,-64, -96, -128].pick_random()
	node.global_position.y = 48
	add_sibling(node)
