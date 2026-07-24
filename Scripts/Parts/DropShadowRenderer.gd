extends Node2D

var shadow_colour := Color.BLACK
@export var offset := Vector2(0, 0)
var shadow_texture: Texture2D = null



func _process(_delta: float) -> void:
	hide()
	if Settings.file.video.drop_shadows == 0:
		return
	show()
	if is_instance_valid(get_tree().current_scene):
		if is_instance_valid(Global.get_game_viewport_camera_2d()):
			$SubViewportContainer/SubViewport.world_2d = Global.get_game_viewport_camera_2d().get_world_2d()
		else:
			return
	else:
		return
	$SubViewportContainer.material.set_shader_parameter("shadow_colour", shadow_colour)
	$SubViewportContainer/SubViewport.size = Global.get_game_viewport().get_visible_rect().size + Vector2(9, 2)
	global_position = Global.get_game_viewport_camera_2d().get_screen_center_position() + offset
	$SubViewportContainer/SubViewport/Camera2D.global_position = Global.get_game_viewport_camera_2d().get_screen_center_position()
	queue_redraw()
