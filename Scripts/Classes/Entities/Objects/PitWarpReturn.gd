extends Node2D

func _ready() -> void:
	if PitWarp.warping:
		for i in get_tree().get_nodes_in_group("Players"):
			i.global_position = global_position
	PitWarp.warping = false
