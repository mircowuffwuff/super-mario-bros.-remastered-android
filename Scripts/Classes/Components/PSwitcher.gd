class_name PSwitcher
extends Node

@export var enabled := true
@export_file("*.tscn") var new_scene := ""
@export var new_offset := Vector2.ZERO

@export var properties := []

var is_switched := false

func _ready() -> void:
	Global.p_switch_toggle.connect(switch_to_other)
	if Global.p_switch_active and not is_switched:
		switch_to_other()

func switch_to_other() -> void:
	if enabled == false: return
	if new_scene != "":
		var new = load(new_scene).instantiate()
		new.global_position = owner.global_position + new_offset
		if new.has_node("PSwitcher"):
			new.get_node("PSwitcher").new_scene = owner.scene_file_path
			new.get_node("PSwitcher").is_switched = true
		for i in properties:
			new.set(i, owner.get(i))
		owner.call_deferred("add_sibling", new)
		owner.queue_free()
