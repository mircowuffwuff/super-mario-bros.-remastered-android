extends Enemy

@export_enum("Up", "Down", "Left", "Right") var pipe_direction := 0
@export var gravity_enabled := true

func _physics_process(delta: float) -> void:
	if gravity_enabled:
		$BasicStaticMovement.handle_movement(delta)
