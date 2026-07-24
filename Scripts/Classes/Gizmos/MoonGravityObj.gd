extends "res://Scripts/Parts/EditorVisibleNode.gd"

@export var effect_player := true
@export var effect_entities := true

func update_vals() -> void:
	$MoonGravity.effect_player = effect_player
	$MoonGravity.effect_entities = effect_entities
