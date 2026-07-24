@tool
extends CollisionShape2D


func _physics_process(_delta: float) -> void:
	update()

func update() -> void:
	var height_to_use = shape.size.y
	position.y = -height_to_use / 2 * scale.y
