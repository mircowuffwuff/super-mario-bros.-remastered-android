class_name BetterAnimatedSprite2D
extends AnimatedSprite2D

@export var do_offset := true

func _ready() -> void:
	if do_offset:
		on_frame_changed()

func _process(_delta: float) -> void:
	if do_offset:
		on_frame_changed()

func on_frame_changed() -> void:
	if sprite_frames == null: return
	var texture = sprite_frames.get_frame_texture(animation, frame)
	if texture != null:
		position.y = -(texture.get_height() / 2.0)
