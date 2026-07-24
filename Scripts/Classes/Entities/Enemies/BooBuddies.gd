extends Enemy

@export_range(25, 180) var length := 80
@export_range(4, 12) var boo_amount := 10
@export var spread_boos := false

const SMOKE_PARTICLE = preload("uid://d08nv4qtfouv1")

func _ready() -> void:
	for i in $BooPositioner.boos:
		i.killed.connect(boo_killed.bind(i), CONNECT_ONE_SHOT)

func _physics_process(delta: float) -> void:
	%RotationJoint.global_rotation_degrees = wrap(%RotationJoint.global_rotation_degrees + (45 * [1, -1][direction]) * delta, 0, 360)
	for i in $BooPositioner.boos:
		if is_instance_valid(i) == false:
			continue
		i.get_node("Sprite").scale.x = sign(get_tree().get_first_node_in_group("Players").global_position.x + 1 - i.global_position.x)

func boo_killed(_direction := 0, boo: Node2D = null) -> void:
	var particle = SMOKE_PARTICLE.instantiate()
	particle.global_position = boo.global_position + Vector2(0, 8)
	add_sibling(particle)
	if (%Boos.get_child_count() + boo_amount) <= 13:
		queue_free()
