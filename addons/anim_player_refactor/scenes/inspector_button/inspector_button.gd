extends EditorInspectorPlugin
signal button_clicked

var button: Button
var button_text: String

func _init(text: String) -> void:
	button_text = text
	
func _can_handle(object: Object) -> bool:
	return object is AnimationPlayer

func _parse_end(object: Object) -> void:
	button = Button.new()
	button.text = button_text
	button.pressed.connect(func(): button_clicked.emit())

	var margins := MarginContainer.new()
	margins.add_theme_constant_override("margin_top", 8)
	margins.add_theme_constant_override("margin_left", 16)
	margins.add_theme_constant_override("margin_bottom", 8)
	margins.add_theme_constant_override("margin_right", 16)
	margins.add_child(button)

	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", 0)
	container.add_child(HSeparator.new())
	container.add_child(margins)

	var container_margins := MarginContainer.new()
	container_margins.add_theme_constant_override("margin_top", 8)
	container_margins.add_theme_constant_override("margin_left", 4)
	container_margins.add_theme_constant_override("margin_bottom", 8)
	container_margins.add_theme_constant_override("margin_right", 4)
	container_margins.add_child(container)

	add_custom_control(container_margins)
