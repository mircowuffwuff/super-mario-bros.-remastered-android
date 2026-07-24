@tool
extends EditorPlugin
const HELPER = preload("uid://kmvo4u8e3h77")

var reminder
var helper

func _enter_tree() -> void:
	helper = HELPER.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, helper)

func _exit_tree() -> void:
	remove_control_from_docks(helper)
