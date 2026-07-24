class_name GibSpawner
extends Node

@export var visuals: Node = null
@export_enum("Spin", "Drop", "Poof") var gib_type := 0
@export var play_death_sfx := true
const ENTITY_GIB = preload("res://Scenes/Prefabs/Entities/EntityGib.tscn")

signal gib_about_to_spawn

@export var global_parent := false


func summon_gib(direction := 1, play_sfx := play_death_sfx, override_gib_type := gib_type) -> void:
	gib_about_to_spawn.emit()
	if play_sfx:
		play_die_sfx()
	if override_gib_type == 2:
		summon_poof()
		return
	var node = ENTITY_GIB.instantiate()
	visuals.show()
	node.visuals = visuals.duplicate()
	node.visuals.set_process(false)
	node.global_position = visuals.global_position
	node.visuals.position = Vector2.ZERO
	node.visuals.set("offset", Vector2.ZERO)
	node.gib_type = override_gib_type
	node.direction = direction
	var parent = owner.get_parent()
	if global_parent:
		parent = Global.current_level
	parent.add_child(node)

func play_die_sfx() -> void:
	AudioManager.play_sfx("kick", owner.global_position)

const SMOKE_PARTICLE = preload("uid://d08nv4qtfouv1")

func summon_poof() -> void:
	var particle = SMOKE_PARTICLE.instantiate()
	particle.global_position = visuals.global_position + Vector2(0, 8)
	owner.add_sibling(particle)

func stomp_die(player: Player, add_combo := true) -> void:
	DiscoLevel.combo_amount += 1
	owner.killed.emit("Hello")
	AudioManager.play_sfx("enemy_stomp", owner.global_position)
	player.enemy_bounce_off(add_combo)
	summon_gib(1, false, 1)
	owner.queue_free()
