extends State

func enter(_msg := {}) -> void:
	owner.velocity.x = 0
	%Sprite.play("Damage")
	%Hitbox.set_deferred("monitoring", false)
	owner.velocity.y = -150
	await get_tree().create_timer(0.3, false).timeout
	state_machine.transition_to("Shell")
	%Hitbox.set_deferred("monitoring", true)

func physics_update(delta: float) -> void:
	%Movement.handle_movement(delta)
