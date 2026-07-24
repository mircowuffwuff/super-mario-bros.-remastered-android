@tool
class_name Chain
extends Node2D

@export var left: Node2D = null
@export var right: Node2D = null

@export var length := 64

@export var steps := 4
@export var has_floor := true
var points := []

var floor := -4.0

@export var texture: Texture = null

func _ready() -> void:
	handle_physics(0)

func _physics_process(delta: float) -> void:
	handle_physics(delta)
	queue_redraw()

func handle_physics(_delta: float) -> void:
	points.clear()
	var distance = left.position.distance_to(right.position)
	var closeness = inverse_lerp(1.0, 0.0, distance / length)
	closeness = clamp(closeness, 0, 1)
	for i in steps + 1:
		var travel = float(i) / steps
		var x_point = lerpf(left.position.x, right.position.x, travel)
		var y_point = lerpf(left.position.y, right.position.y, travel)
		var dip_amount = 1 - pow((travel * 2) - 1, 2)
		y_point += abs(dip_amount * closeness * -(length / 2))
		if has_floor:
			y_point = clamp(y_point, -INF, floor + 5)
		var point = Vector2(x_point, y_point)
		points.append(point)

func _draw() -> void:
	var idx := 0
	for i in points:
		idx += 1
		if idx <= 1: continue
		draw_texture(texture, i - Vector2(8, 8))
