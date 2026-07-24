extends Node

func _ready() -> void:
	owner.add_to_group("AmountLimiters")

func run_check(tree: SceneTree) -> bool:
	for i in tree.get_nodes_in_group("AmountLimiters"):
		if i.scene_file_path == owner.scene_file_path:
			return true
	return false
