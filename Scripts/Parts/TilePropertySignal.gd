class_name SignalProperty
extends Control

signal start_connecting()

var connections := 0
var node: Node = null

func _process(_delta: float) -> void:
	if node != null:
		if node.has_node("SignalExposer"):
			connections = node.get_node("SignalExposer").connections.size()
	$Connections.text = "Connections: (" + str(connections) + "):"

func start_connection() -> void:
	start_connecting.emit()

func node_selected() -> void:
	pass
