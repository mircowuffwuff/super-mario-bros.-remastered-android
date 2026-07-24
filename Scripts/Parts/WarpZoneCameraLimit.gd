extends Node2D

@export var y_limit := -176

@onready var camera := Global.get_game_viewport().get_camera_2d()

@onready var old_limit = Player.camera_right_limit


func enter_screen() -> void:
	if Global.get_game_viewport().get_camera_2d().get_target_position().x > global_position.x: return
	Player.camera_right_limit = int(global_position.x)

func _physics_process(_delta: float) -> void:
	if camera != null:
		var player = get_tree().get_first_node_in_group("Players")
		if (player.global_position.y <= y_limit + 1 and player.global_position.x + player.get_node("CameraHandler").camera_offset.x >= player.camera.get_screen_center_position().x) or player.global_position.x >= global_position.x - 16:
			return_to_normal()

func return_to_normal() -> void:
	Player.camera_right_limit = old_limit
