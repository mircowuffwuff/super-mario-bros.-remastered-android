extends Node2D

var moving := false

@export var path: PathFollow2D = null
@export var time_needed := [60, 45, 30]

const COLOURS := ["White", "Green", "Red", "Black", "Gold"]

var last_position := global_position
var tween: Tween = null

@export var force_colour := -1

func play_laugh_animation() -> void:
	if get_tree().get_first_node_in_group("BooSwitches") != null:
		$Warning.show()
	$Sprite.play("Laugh")
	await get_tree().create_timer(1, false).timeout
	$Warning.hide()
	if moving:
		$Sprite.play("Idle")

func _ready() -> void:
	if force_colour != -1:
		BooRaceHandler.boo_colour = force_colour
	$Sprite.play("Lose")
	$OffScreenIcon.frame =  BooRaceHandler.boo_colour
	$GoldParticles.visible = BooRaceHandler.boo_colour == 4
	get_tree().get_first_node_in_group("Players").dead.connect(func(): $Sprite.play("Win"))

func _process(_delta: float) -> void:
	if Global.current_game_mode == Global.GameMode.BOO_RACE:
		handle_off_screen_icon()

func handle_off_screen_icon() -> void:
	$OffScreenIcon.visible = $Sprite/VisibleOnScreenNotifier2D.is_on_screen() == false and moving
	var sprite_position = $Sprite.global_position
	var screen_center = Global.get_game_viewport_camera_2d().get_screen_center_position()
	var screen_size = Global.get_game_viewport().get_visible_rect().size
	sprite_position.x = clamp(sprite_position.x, (screen_center.x - (screen_size.x / 2)) + 8, (screen_center.x + (screen_size.x / 2)) - 8)
	sprite_position.y = clamp(sprite_position.y, (screen_center.y - (screen_size.y / 2)) + 8, (screen_center.y + (screen_size.y / 2)) - 8)
	$OffScreenIcon.global_position = sprite_position
	if global_position.x > get_tree().get_first_node_in_group("Players").global_position.x and path.progress_ratio >= 0.8:
		$OffScreenIcon/Animation.play("CloseFlash")
		$Sprite.play("Win")

func _physics_process(_delta: float) -> void:
	var dir = sign(global_position.x - last_position.x)
	if moving and dir != 0:
		$Sprite.scale.x = dir
	last_position = global_position

func flag_die() -> void:
	tween.kill()
	$Sprite.play("Lose")
	moving = false

func move_tween() -> void:
	if path == null:
		return
	moving = true
	$Sprite.play("Idle")
	tween = create_tween()
	tween.tween_property(path, "progress_ratio", 1, time_needed[BooRaceHandler.boo_colour])
	await tween.finished
	boo_win()

func boo_win() -> void:
	$Sprite.play("Win")
	get_tree().call_group("Players", "time_up")
