extends Gizmo

var amount := 0
@export_range(0, 99) var total_needed := -1
@export var reset_on_total_reached := false

signal total_reached

func _process(_delta: float) -> void:
	%Total.text = str(amount)

func increment() -> void:
	amount += 1
	update()
	if reset_on_total_reached:
		amount = amount % total_needed

func update() -> void:
	if total_needed <= 0:
		$SignalExposer.update_animation()
	if amount == total_needed:
		total_reached.emit()
