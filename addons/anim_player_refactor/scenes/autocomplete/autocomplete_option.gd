## Autocomplete Class
extends OptionButton

## LineEdit.text_change_rejected
signal text_change_rejected(rejected_substring: String)
## LineEdit.text_changed
signal text_changed(new_text: String)
## LineEdit.text_submitted
signal text_submitted(new_text: String)

## LineEdit component
var edit: LineEdit = LineEdit.new()

@export var get_autocomplete_options: Callable = func(text: String): return []

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	edit.custom_minimum_size = size
	get_popup().unfocusable = true
	
	add_child(edit)
	edit.reset_size()
	
	edit.text_change_rejected.connect(func(arg): text_change_rejected.emit(arg))
	edit.text_changed.connect(func(arg): text_changed.emit(arg))
	edit.text_submitted.connect(func(arg): text_submitted.emit(arg))
	
	edit.text_changed.connect(_update_options)

	edit.focus_entered.connect(_update_options)
	edit.focus_exited.connect(clear)
	
	get_autocomplete_options = func(text: String):
		return [
			"test",
			"ashina",
			"hello"
		].filter(func(el: String): return el.contains(text))

func _update_options(text: String = edit.text):
	clear()
	var options = get_autocomplete_options.call(text)
	
	for option in options:
		if typeof(option) == TYPE_STRING:
			add_item(option)
	
	show_popup()


