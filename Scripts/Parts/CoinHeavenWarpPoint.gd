class_name CoinHeavenWarpPoint
extends Node2D

@export_file("*.tscn") var heaven_scene := ""
@export_enum("Room 0", "Room 1", "Room 2", "Room 3", "Room 4") var target_subarea := 0:
	set(value):
		target_subarea = value
		subarea_to_warp_to = target_subarea

static var subarea_to_warp_to := -1
static var subarea_return := -1

func _ready() -> void:
	Level.vine_warp_level = heaven_scene
	subarea_to_warp_to = target_subarea
	if Level.in_vine_level and Global.level_editor_is_editing() == false:
		Level.in_vine_level = false
		if PipeArea.exiting_pipe_id == -1:
			for i in get_tree().get_nodes_in_group("Players"):
				i.global_position = global_position
				i.reset_physics_interpolation()
				i.recenter_camera()
