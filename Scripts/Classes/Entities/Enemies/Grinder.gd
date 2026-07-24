extends Enemy

var can_rotate := true

var rot := 0.0

func _physics_process(delta: float) -> void:
	if can_rotate:
		rot += 180 * delta
	else:
		$Sprite.global_rotation_degrees = 0
		return
	if Settings.file.visuals.firebar_style == 1:
		$Sprite.global_rotation_degrees = rot
	else:
		$Sprite.global_rotation_degrees = snappedf(rot, 11.25)
