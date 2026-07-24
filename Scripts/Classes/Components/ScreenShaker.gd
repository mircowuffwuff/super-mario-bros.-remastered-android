class_name ScreenShaker
extends Node

var shake_power := 0.0
var shake_time := 0.0

var wave := 0.0

var enabled := true

func shake_screen(amount := 0.0, duration := 0.0) -> void:
	if enabled == false:
		return
	shake_power += amount
	shake_time = duration

func _physics_process(delta: float) -> void:
	if shake_time > 0:
		handle_shaking(delta)
	else:
		if get_viewport().get_camera_2d() != null:
			get_viewport().get_camera_2d().offset.y = 0

func handle_shaking(delta: float) -> void:
	shake_time -= delta
	wave = fmod(wave + delta, PI * 2)
	if get_viewport().get_camera_2d() != null:
		get_viewport().get_camera_2d().offset.y = (-abs(sin(wave * 64)))
