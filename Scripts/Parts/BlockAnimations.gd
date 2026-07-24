extends Node2D

func _ready() -> void:
	set_process(false)
	if owner is Block:
		$Joint.remote_path = $Joint.get_path_to(owner.visuals)

func _process(_delta: float) -> void:
	owner.visuals.z_index = z_index

func bounce_block() -> void:
	set_process(true)
	owner.visuals.show()
	owner.visuals.z_index = 3
	owner.get_parent().move_child(owner, -1)
	owner.bouncing = true
	$Animations.stop()
	$Animations.play("BlockHit")
	await $Animations.animation_finished
	owner.visuals.z_index = 0
	owner.bouncing = false
	set_process(false)
