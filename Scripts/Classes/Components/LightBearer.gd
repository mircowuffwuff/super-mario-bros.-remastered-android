class_name LightBarer
extends Node2D

@export var size := 0.5

func _enter_tree() -> void:
	add_to_group("Lights")
	if DarknessEffect.current_effect != null:
		DarknessEffect.current_effect.add_light_to_node(self)
