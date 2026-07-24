extends Enemy

@export var player_range := 24

@export_enum("Up", "Down", "Left", "Right") var pipe_direction := 0

@export var rise_animation := "Rise"

@export var upside_down_hitbox: Node2D = null

func _enter_tree() -> void:
	$Animations.play("Hide")

func _ready() -> void:
	if is_equal_approx(abs(global_rotation_degrees), 180) == false:
		upside_down_hitbox.queue_free()
	$Timer.start(0.5)

func rise_up() -> void:
	var player = get_tree().get_first_node_in_group("Players")
	if pipe_direction < 2:
		if abs(player.global_position.x - global_position.x) >= player_range:
			$Animations.play(rise_animation)
	elif (abs(player.global_position.y - global_position.y) >= player_range and abs(player.global_position.x - global_position.x) >= player_range * 2):
			$Animations.play(rise_animation)
	if $Animations.is_playing():
		await $Animations.animation_finished
	$Timer.start(2)
