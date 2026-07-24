class_name HardModeForce
extends Node

static var enabled := false

func _enter_tree() -> void:
	enabled = true

func _exit_tree() -> void:
	enabled = false
