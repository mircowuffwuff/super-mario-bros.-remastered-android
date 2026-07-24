extends Node2D

@export_range(1, 100, 1.0) var percentage_chance := 50

signal passed

func check() -> void:
	if randi_range(1, 100) <= percentage_chance:
		passed.emit()
