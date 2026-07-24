class_name TrackPiece
extends Node2D

var editing := false

var mouse_in_areas := 0

var pieces := []

var idx := 0

var starting_direction := Vector2i.ZERO
var connecting_direction := Vector2i.UP

const SPRITE_COORDS := {
	Vector2i.ZERO: Vector2(112, 16),
	Vector2i.RIGHT: Vector2(0, 0),
	Vector2i.LEFT: Vector2(16, 0),
	Vector2i.DOWN: Vector2(32, 0),
	Vector2i.UP: Vector2(48, 0),
	Vector2i(1, 1): Vector2(64, 0),
	Vector2i(-1, 1): Vector2(80, 0),
	Vector2i(-1, -1): Vector2(96, 0),
	Vector2i(1, -1): Vector2(112, 0),
}
