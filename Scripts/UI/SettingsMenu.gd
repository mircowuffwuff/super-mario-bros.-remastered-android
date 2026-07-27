extends Control

@onready var current_container: Control = $PanelContainer/MarginContainer/VBoxContainer/Video

@export var containers: Array[Control]
@export var disabled_containers: Array[Control]

var category_select_active := false
var category_index := 0

signal closed

var can_move := true

var active = false

static var physics_warning_shown := false

signal opened

@onready var controller_reset_label: Label = $PanelContainer/MarginContainer/VBoxContainer/Controller/Label
var controller_resetting := false
var controller_reset_time : float
var last_controller_reset : float

@onready var osc_reset_label: Label = $PanelContainer/MarginContainer/VBoxContainer/OnScreenControls/Label
var osc_resetting := false
var osc_reset_time : float
var last_osc_reset : float

func _process(_delta: float) -> void:
	category_select_active = current_container.selected_index == -1 and active
	%Category.text = tr(current_container.category_name)
	%Icon.region_rect.position.x = category_index * 24
	
	for i in [%LeftArrow, %RightArrow]:
		i.modulate.a = int(current_container.selected_index == -1)
	if Global.multibind_action_just_pressed("ui_accept"):
		$CanvasLayer.hide()
	for i in containers.size():
		containers[i].active = category_index == i and active
		if SelectableInputOption.rebinding_input == false:
			containers[i].can_input = can_move
			for x in containers[i].options:
				x.focus_mode = 2 if can_move else 0
	for i in disabled_containers:
		i.active = false
	if category_select_active and active and can_move:
		handle_inputs()
	if Global.multibind_action_just_pressed("ui_back") and active and current_container.can_input and can_move:
		close()
	
	if controller_resetting:
		var remaining := 3.0 - (Time.get_unix_time_from_system() - controller_reset_time)
		if remaining < 0.0001:
			controller_reset_label.text = "SUCCESSFULLY RESET BINDINGS!"
			# since the multibind thingy, this did not work anymore.
			# to patch this dirtily, i reintroduced the old method
			# of input detection to the script in SettingsMenu.tscn
			Input.action_press("ui_reset_keybindings")
			Input.action_release("ui_reset_keybindings")
			last_controller_reset = Time.get_unix_time_from_system()
		else:
			var remaining_seconds : int = floor(remaining)
			var remaining_millis : int = floor(remaining*1000) - remaining_seconds*1000
			var remaining_millis_s : String = str(remaining_millis) if remaining_millis > 99 else "0" + str(remaining_millis) if remaining_millis > 9 else "00" + str(remaining_millis) if remaining_millis > 0 else "000"
			controller_reset_label.text = "HOLD FOR %s.%sS TO RESET..." % [remaining_seconds, remaining_millis_s ]
	elif controller_reset_label.text != "TAP AND HOLD HERE TO RESET." and Time.get_unix_time_from_system() - last_controller_reset > 3.0:
		controller_reset_label.text = "TAP AND HOLD HERE TO RESET."
	
	if osc_resetting:
		var remaining := 3.0 - (Time.get_unix_time_from_system() - osc_reset_time)
		if remaining < 0.0001:
			osc_reset_label.text = "SUCCESSFULLY RESET OPTIONS!"
			
			$PanelContainer/MarginContainer/VBoxContainer/OnScreenControls/Visibility.selected_index = 0
			$PanelContainer/MarginContainer/VBoxContainer/OnScreenControls/Visibility.emit_signal("value_changed")
			$PanelContainer/MarginContainer/VBoxContainer/OnScreenControls/TransitionVisibility.selected_index = 1
			$PanelContainer/MarginContainer/VBoxContainer/OnScreenControls/TransitionVisibility.emit_signal("value_changed")
			$PanelContainer/MarginContainer/VBoxContainer/OnScreenControls/HapticFeedback.selected_index = 0
			$PanelContainer/MarginContainer/VBoxContainer/OnScreenControls/HapticFeedback.emit_signal("value_changed")
			
			last_osc_reset = Time.get_unix_time_from_system()
		else:
			var remaining_seconds : int = floor(remaining)
			var remaining_millis : int = floor(remaining*1000) - remaining_seconds*1000
			var remaining_millis_s : String = str(remaining_millis) if remaining_millis > 99 else "0" + str(remaining_millis) if remaining_millis > 9 else "00" + str(remaining_millis) if remaining_millis > 0 else "000"
			osc_reset_label.text = "HOLD FOR %s.%sS TO RESET..." % [remaining_seconds, remaining_millis_s ]
	elif osc_reset_label.text != "TAP AND HOLD HERE TO RESET." and Time.get_unix_time_from_system() - last_osc_reset > 3.0:
		osc_reset_label.text = "TAP AND HOLD HERE TO RESET."

func show_physics_warning(value := 0) -> void:
	if physics_warning_shown:
		return
	$CanvasLayer.visible = not value
	if value == 0:
		physics_warning_shown = true
		AudioManager.play_global_sfx("bump")
		can_move = false
		await $CanvasLayer.visibility_changed
		can_move = true

func handle_inputs() -> void:
	var direction := 0
	if Global.multibind_action_just_pressed("ui_left"):
		category_index -= 1
		direction = -1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	if Global.multibind_action_just_pressed("ui_right"):
		category_index += 1
		direction += 1
		if Settings.file.audio.extra_sfx == 1:
			AudioManager.play_global_sfx("menu_move")
	category_index = wrap(category_index, 0, containers.size())
	current_container = containers[category_index]
	while disabled_containers.has(current_container):
		category_index = wrap(category_index + direction, 0, containers.size())
		current_container = containers[category_index]

func open_pack_config_menu(pack: ResourcePackContainer) -> void:
	$ResourcePackConfigMenu.config_json = pack.config
	$ResourcePackConfigMenu.json_path = pack.config_path
	$ResourcePackConfigMenu.open()
	can_move = false
	await $ResourcePackConfigMenu.closed
	can_move = true

func open() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	opened.emit()
	update_all_starting()
	$PanelContainer/MarginContainer/VBoxContainer/KeyboardControls.selected_index = -1
	$PanelContainer/MarginContainer/VBoxContainer/Controller.selected_index = -1
	show()
	update_minimum_size()
	current_container.show()
	current_container.active = true
	await get_tree().process_frame
	active = true

func update_all_starting() -> void:
	get_tree().call_group("Options", "update_starting_values")
	%Flag.region_rect.position.x = Global.lang_codes.find(TranslationServer.get_locale()) * 16
	$PanelContainer/MarginContainer/VBoxContainer/Video/Language.selected_index = Global.lang_codes.find(Settings.file.game.lang)

func close() -> void:
	$CanvasLayer.hide()
	hide()
	active = false
	closed.emit()
	await get_tree().process_frame
	Settings.save_settings()
	process_mode = Node.PROCESS_MODE_DISABLED

func on_controller_reset_button_down() -> void:
	#Input.action_press("ui_reset_keybindings")
	controller_resetting = true
	controller_reset_time = Time.get_unix_time_from_system()

func on_controller_reset_button_up() -> void:
	#Input.action_release("ui_reset_keybindings")
	controller_resetting = false

func on_osc_reset_button_down() -> void:
	osc_resetting = true
	osc_reset_time = Time.get_unix_time_from_system()

func on_osc_reset_button_up() -> void:
	osc_resetting = false
