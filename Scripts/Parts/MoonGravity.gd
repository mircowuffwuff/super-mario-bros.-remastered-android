class_name MoonGravity
extends Node

@export var new_gravity := 5
@export var effect_player := true
@export var effect_entities := true
const OLD_GRAVITY := 10

static var active := false

func _ready() -> void:
	activate()

func _exit_tree() -> void:
	deactivate()

func start() -> void:
	if %SignalExposer.total_inputs <= 0:
		activate()

func activate() -> void:
	if effect_entities:
		Global.entity_gravity = new_gravity
	if effect_player:
		for i: Player in get_tree().get_nodes_in_group("Players"):
			i.low_gravity = true
	active = true

func deactivate() -> void:
	if effect_entities:
		Global.entity_gravity = OLD_GRAVITY
	if effect_player:
		for i: Player in get_tree().get_nodes_in_group("Players"):
			i.low_gravity = false
	active = false

func toggle() -> void:
	if active:
		deactivate()
	else:
		activate()
