extends Node2D

var number_of_inputs := 0

func _process(_delta: float) -> void:
	$Sprite.frame = clamp(number_of_inputs, 0, 4)

func turn_on() -> void:
	number_of_inputs += 1

func turn_off() -> void:
	number_of_inputs -= 1

func pulse() -> void:
	turn_on()
	await get_tree().create_timer(0.1, false).timeout
	turn_off()
