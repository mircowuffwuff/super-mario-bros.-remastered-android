extends Enemy
const EXPLOSION = preload("uid://clbvyne1cr8gp")
@export var timer := 5.0

var can_move := true

func _ready() -> void:
	$Movement.auto_call = can_move

func _physics_process(delta: float) -> void:
	timer -= delta
	if timer <= 2.0:
		%FlashAnimation.play("Flash")
	if timer <= 0:
		explode()
		timer = 99
	%Sprite.scale.x = direction

func explode() -> void:
	$AnimationPlayer.play("Explode")
	await $AnimationPlayer.animation_finished
	summon_explosion()
	queue_free()

func kick(object: Node2D) -> void:
	AudioManager.play_sfx("kick", global_position)
	if object is Player:
		object.kick_anim()
	var kick_dir = sign(global_position.x - object.global_position.x)
	var kick_amount = 150
	if object is not Player:
		kick_amount = 100
	velocity.x = kick_amount * kick_dir
	direction = kick_dir
	velocity.y = -100

func summon_explosion() -> void:
	var node = EXPLOSION.instantiate()
	node.global_position = global_position + Vector2(0, -8)
	AudioManager.play_sfx("explode", node.global_position)
	add_sibling(node)
