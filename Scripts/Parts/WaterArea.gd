class_name WaterArea
extends Area2D

@export var max_height := -158

func _physics_process(_delta: float) -> void:
	if is_instance_valid(Global.current_level):
		max_height = Global.current_level.vertical_height + 50
	for i in get_tree().get_nodes_in_group("Players"):
		if i.global_position.y <= max_height:
			i.velocity.y += 20
		i.global_position.y = clamp(i.global_position.y, max_height - 4, INF)

func toggle() -> void:
	$CollisionShape2D.set_deferred("disabled", !$CollisionShape2D.disabled)


func on_level_start() -> void:
	$CollisionShape2D.set_deferred("disabled", $SignalExposer.total_inputs > 0)
