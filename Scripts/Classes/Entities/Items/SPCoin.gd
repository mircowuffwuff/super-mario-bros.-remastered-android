extends Node2D

@export var amount := 10

signal collected

var y_vel := 0.0

var can_collect := true

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	y_vel += 15
	global_position.y += y_vel * delta

func collect() -> void:
	if can_collect == false:
		return
	can_collect = false
	set_physics_process(true)
	y_vel = -250
	$Sprite.play("Spin")
	Global.coins += amount
	Global.score += 100
	AudioManager.play_sfx("sp_coin", global_position)
	collected.emit()
	await get_tree().create_timer(0.5, false).timeout
	queue_free()


func on_area_entered(area: Area2D) -> void:
	if area.owner is Projectile:
		if area.owner.COLLECT_COINS:
			collect()
