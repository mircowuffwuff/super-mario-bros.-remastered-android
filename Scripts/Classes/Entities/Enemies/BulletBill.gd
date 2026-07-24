class_name BulletBill
extends Enemy

static var amount := 0

var can_despawn := false

const MOVE_SPEED := 96
var cannon := false

func _ready() -> void:
	$Sprite.scale.x = direction
	if cannon:
		await get_tree().create_timer(0.2, false).timeout
	z_index = 0

func _physics_process(delta: float) -> void:
	global_position.x += (90 * delta) * direction

func on_screen_entered() -> void:
	if Global.level_editor != null:
		if Global.level_editor.current_state == LevelEditor.EditorState.PLAYTESTING or Global.current_game_mode == Global.GameMode.CUSTOM_LEVEL:
			AudioManager.play_sfx("cannon", global_position)
	else:
		AudioManager.play_sfx("cannon", global_position)
