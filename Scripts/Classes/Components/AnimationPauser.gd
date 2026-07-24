class_name AnimationPauser
extends Node

@export var animation_player: AnimationPlayer = null

@export var paused := false

signal just_paused
signal resumed

func _process(_delta: float) -> void:
	animation_player.speed_scale = int(not paused)

func pause() -> void:
	paused = true
	just_paused.emit()

func resume() -> void:
	paused = false
	resumed.emit()
