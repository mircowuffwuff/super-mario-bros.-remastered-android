extends Node2D

@export_enum("Down", "Up", "Left", "Right", "None") var post := 0
@export_enum("E-Arrow", "W-Arrow", "NE-Arrow", "SW-Arrow", "N-Arrow", "S-Arrow", "NW-Arrow", "SE-Arrow", "Square", "Warning", "Skull", "None") var head := 0

const OFFSETS := [Vector2(0, -4), Vector2(0, 4), Vector2(4, 0), Vector2(-4, 0), Vector2(0, 0)]

func _ready() -> void:
	update()

func update() -> void:
	%Post.visible = post < 4
	%Head.visible = head < 11
	if %Post.visible:
		%Post.frame = post
	if %Head.visible:
		%Head.frame = head 
	$Joint.position = OFFSETS[post]
