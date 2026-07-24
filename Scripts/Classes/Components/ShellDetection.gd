class_name ShellDetection
extends Node

@export var hitbox: Area2D = null
@export var add_combo := true
signal moving_shell_entered(shell: Node2D)

func _ready() -> void:
	hitbox.area_entered.connect(area_entered)

func area_entered(area: Area2D) -> void:
	if area.owner is Shell and area.owner != owner:
		if abs(area.owner.velocity.x) > 0:
			moving_shell_entered.emit(area.owner)
			if add_combo:
				area.owner.add_combo()

func destroy_shell(shell: Shell) -> void:
	shell.die_from_object(owner)
