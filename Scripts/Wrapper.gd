extends Node

@onready var game_viewport = $CenterContainer/SubViewportContainer/SubViewport
@onready var center_container = $CenterContainer

var thread : Thread

func _ready() -> void:
	await get_tree().process_frame
	await change_scene_to("res://Scenes/Levels/Disclaimer.tscn")

func change_scene_to(scene_path) -> void:
	for child in game_viewport.get_children():
		if child.name != "Global":
			child.queue_free()
			await child.tree_exited
	
	#if scene_path is String:
	#	get_tree().change_scene_to_file(scene_path)
	#elif scene_path is PackedScene:
	#	get_tree().change_scene_to_packed(scene_path)
	
	var new_scene
	if scene_path is String:
		print("----")
		print(scene_path)
		print(load(scene_path))
		print(load(scene_path).instantiate())
		print("----")
		new_scene = load(scene_path).instantiate()
	elif scene_path is PackedScene:
		new_scene = scene_path.instantiate()
	game_viewport.add_child(new_scene)
	
	await new_scene.ready

func get_game_viewport() -> SubViewport:
	return game_viewport
