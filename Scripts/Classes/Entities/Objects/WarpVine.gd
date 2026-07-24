class_name WarpVine
extends Node2D

func _physics_process(_delta: float) -> void:
	$VineJoint/Vine.top_point = global_position.y

func start() -> void:
	$VineJoint/Vine.can_stop = false
	await get_tree().process_frame
	$VineJoint/Vine.cutscene = true
	$VineJoint/Vine.do_cutscene.call_deferred()
