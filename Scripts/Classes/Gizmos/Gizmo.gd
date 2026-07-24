class_name Gizmo
extends Node2D

func _ready() -> void:
	set_physics_process(false)

func start_connection() -> void:
	set_physics_process(true)

func connection_finished() -> void:
	set_physics_process(false)
	queue_redraw()

func _physics_process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if is_physics_processing():
		draw_line(Vector2.ZERO, get_local_mouse_position(), Color.RED, 2, false)
