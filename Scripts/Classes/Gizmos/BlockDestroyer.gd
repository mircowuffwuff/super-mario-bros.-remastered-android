extends Node2D

func destroy_blocks() -> void:
	$Area.position = $Area.position * Vector2(1, -1)
	await get_tree().physics_frame
	for i in $Area.get_overlapping_bodies():
		if i is Block:
			if i.destructable:
				i.destroy()
