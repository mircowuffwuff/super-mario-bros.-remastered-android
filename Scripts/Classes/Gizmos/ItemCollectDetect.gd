extends Node2D

func _physics_process(_delta: float) -> void:
	for i in get_parent().get_children():
		if i.has_signal("collected"):
			if i.collected.is_connected($SignalExposer.emit_pulse) == false:
				i.collected.connect($SignalExposer.emit_pulse)
