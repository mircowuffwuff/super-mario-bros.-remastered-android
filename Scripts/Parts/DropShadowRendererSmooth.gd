extends Node

@onready var sub_viewport: SubViewport = %SubViewport
@onready var camera: Camera2D = %Camera
@onready var point: Node2D = %Point

var enabled := true

const day_colour := Color("000000")
const night_colour := Color("5e5e5e")

func _ready() -> void:
	await get_tree().physics_frame
	sub_viewport.set_world_2d(Global.get_game_viewport().get_world_2d())

func _physics_process(_delta: float) -> void:
	if Global.get_game_viewport_camera_2d() != null:
		camera.global_position = Global.get_game_viewport_camera_2d().get_screen_center_position()
	camera.zoom = Vector2i(Vector2.ONE / $"%Container".scale)
	point.global_position = camera.global_position
	var colour := day_colour
	$%Container.material.set_shader_parameter("shadow_colour", colour)

func _exit_tree() -> void:
	pass
	#sub_viewport.set_world_2d(null)
