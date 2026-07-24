class_name TilePropertyContainer
extends HBoxContainer

signal value_changed(this, new_value)

var max_value = 0
var min_value = 0
var property_step = 1.0

var values := {}

signal exit_changed(new_value: bool)

signal start_value_changed(new_value)

var value = null

var editing_node: Node = null

@export var tile_property_name := ""

func _ready() -> void:
	%Label.text = tile_property_name.replace("_", " ") + ":"

func set_value(new_value = null) -> void:
	value = new_value
	value_changed.emit(self, new_value)

func set_starting_value(start_value = null) -> void:
	start_value_changed.emit(start_value)
