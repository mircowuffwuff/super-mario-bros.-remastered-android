class_name SignalDisconnector
extends Node

@export var node: Node = null
@export var signal_name := ""

func _enter_tree() -> void:
	disconnect_all()

func disconnect_all() -> void:
	if node == null or signal_name == "": return
	
	var sig: Signal = node.get(signal_name)
	for i in sig.get_connections():
		sig.disconnect(i.callable)
