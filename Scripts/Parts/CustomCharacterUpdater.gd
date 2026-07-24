class_name CustomCharacterUpdater
extends Node

const OLD_TO_NEW_VALS := {
	"AIR_ACCEL": ["AIR_WALK_ACCEL", "AIR_RUN_ACCEL", "AIR_BACKWARDS_ACCEL"],
	"AIR_SKID": ["AIR_WALK_SKID_ACCEL", "AIR_RUN_SKID_ACCEL", "AIR_BACKWARDS_SKID_ACCEL"],
	"DECEL": ["GROUND_WALK_DECEL", "GROUND_RUN_DECEL"],
	"FALL_GRAVITY": ["FALL_GRAVITY_IDLE", "FALL_GRAVITY_WALK", "FALL_GRAVITY_RUN"],
	"JUMP_GRAVITY": ["JUMP_GRAVITY_IDLE", "JUMP_GRAVITY_WALK", "JUMP_GRAVITY_RUN"],
	"JUMP_HEIGHT": ["JUMP_SPEED_IDLE", "JUMP_SPEED_WALK", "JUMP_SPEED_RUN"],
}

const VAL_MODS := {
	"AIR_SKID": 3.0
}

const BASE := {
	"name": "",
	"physics": {
		"PHYSICS_PARAMETERS": {
			"Default": {},
			"Small": {},
			"Big": {},
			"Fire": {},
		},
		"CLASSIC_PARAMETERS": {
			"Default": {},
			"Small": {},
			"Big": {},
			"Fire": {},
		},
		"ENDING_PARAMETERS": {
			"Default": {},
			"Small": {},
			"Big": {},
			"Fire": {},
		},
		"DEATH_PARAMETERS": {
			"Default": {}
		},
		"COSMETIC_PARAMETERS": {
			"Default": {},
			"Small": {},
			"Big": {},
			"Fire": {},
		},
		"POWER_PARAMETERS": {
			"Default": {},
			"Fire": {}
		}
	},
}

static func update_json(json := {}) -> Dictionary:
	var new_json = BASE.duplicate_deep()
	if json.has("physics"):
		for i in json.physics.keys():
			if OLD_TO_NEW_VALS.has(i):
				for x in OLD_TO_NEW_VALS[i]:
					new_json.physics.PHYSICS_PARAMETERS.Default[x] = json.physics[i] * VAL_MODS.get(i, 1)
			else:
				new_json.physics.PHYSICS_PARAMETERS.Default[i] = json.physics[i]
		new_json.physics.PHYSICS_PARAMETERS.Default.COLLISION_SIZE = [8 * json.big_hitbox_scale[0], 28 * json.big_hitbox_scale[1]] 
		new_json.physics.PHYSICS_PARAMETERS.Default.CROUCH_COLLISION_SIZE = [8 * json.big_hitbox_scale[0], 14 * json.big_hitbox_scale[1]]
		new_json.physics.PHYSICS_PARAMETERS.Small.COLLISION_SIZE = [8 * json.big_hitbox_scale[0], 14 * json.big_hitbox_scale[1]]
		new_json.physics.PHYSICS_PARAMETERS.Small.CROUCH_COLLISION_SIZE = [8 * json.big_hitbox_scale[0], 14 * json.big_hitbox_scale[1]]
	new_json.name = json.name
	return new_json
