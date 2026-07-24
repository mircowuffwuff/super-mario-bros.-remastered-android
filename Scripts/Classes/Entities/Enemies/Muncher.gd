extends Enemy

@export_enum("Up", "Down", "Left", "Right") var facing_direction := 0
@export var enable_gravity := true

func _physics_process(delta: float) -> void:
	if enable_gravity: $Movement.handle_movement(delta)


func on_modifier_applied() -> void:
	global_rotation_degrees = [0, 180, -90, 90][facing_direction]
