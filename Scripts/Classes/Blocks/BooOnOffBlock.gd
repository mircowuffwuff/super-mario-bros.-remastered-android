extends StaticBody2D

@export var active := false

var player_in_area := false
var player_stuck := false

@export var hurtbox: CollisionShape2D = null

func turned_on() -> void:
	player_stuck = false
	active = true
	if player_in_area:
		player_stuck = true
		return
	update()

func turned_off() -> void:
	player_stuck = false
	active = false
	update()

func update() -> void:
	if active:
		$Sprite.play("On")
	else:
		$Sprite.play("Off")
	$Collision.set_deferred("disabled", not active)
	if hurtbox != null:
		hurtbox.set_deferred("disabled", not active)

func on_player_entered(_player: Player) -> void:
	player_in_area = true

func on_player_exited(_player: Player) -> void:
	player_in_area = false
	if player_stuck and active:
		player_stuck = false
		update()
