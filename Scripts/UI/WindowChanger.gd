extends Node

func window_mode_changed(new_value := 0) -> void:
	match new_value:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	Settings.file.video.mode = new_value

func null_function(_fuck_you := 0) -> void:
	pass

# DawnLR: Now that we have screen resolutions, we better also have a little more window control.
func window_multiplier_changed(new_value := 0) -> void:
	pass

func window_size_changed(new_value := 0) -> void:
	var center_container : CenterContainer = get_tree().root.get_node("Wrapper/CenterContainer")
	var screen_width = floor(center_container.size.x)
	#var x = mini(screen_width if new_value == 2 else 384 if new_value == 1 else 256, screen_width)
	var x = mini(screen_width if new_value == 4 else 426 if new_value == 3 else 384 if new_value == 2 else 320 if new_value == 1 else 256, screen_width)
	#print("WindowChanger/x: ", x)
	var game_viewport : SubViewport = get_tree().root.get_node("Wrapper/CenterContainer/SubViewportContainer/SubViewport")
	var game_viewport_container : SubViewportContainer = get_tree().root.get_node("Wrapper/CenterContainer/SubViewportContainer")
	game_viewport.size.x = x
	game_viewport_container.size.x = x
	
	Settings.file.video.size = new_value

	# TODO should this stay? compare with release 9s sources
	var idx = new_value
	var res = Global.RESOLUTIONS[new_value]
	get_tree().root.content_scale_size = res
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND if idx == Global.RESOLUTIONS.size() - 1 else Window.CONTENT_SCALE_ASPECT_KEEP

func vsync_changed(new_value := 0) -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if new_value == 1 else DisplayServer.VSYNC_DISABLED)
	
	Settings.file.video.vsync = new_value

func drop_shadows_changed(new_value := 0) -> void:
	Settings.file.video.drop_shadows = new_value

func scaling_changed(new_value := 0) -> void:
	get_tree().root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER if new_value == 0 else Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	Settings.file.video.scaling = new_value

func visuals_changed(new_value := 0) -> void:
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT if new_value == 0 else Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	RenderingServer.viewport_set_snap_2d_transforms_to_pixel(get_tree().root.get_viewport_rid(), not new_value)
	Settings.file.video.visuals = new_value

func hud_style_changed(new_value := 0) -> void:
	Settings.file.video.hud_size = new_value

func language_changed(new_value := 0) -> void:
	TranslationServer.set_locale(Global.lang_codes[new_value])
	Settings.file.game.lang = Global.lang_codes[new_value]
	%Flag.region_rect.position.x = new_value * 16

func frame_limit_changed(new_value := 0) -> void: 
	
	var new_framerate := 0
	match new_value: 
		
		1: new_framerate = 60
		2: new_framerate = 120
		3: new_framerate = 144
		4: new_framerate = 240
	
	Engine.set_max_fps(new_framerate)
	Settings.file.video.frame_limit = new_value

func set_window_size(value := []) -> void:
	print(Settings.file.video)
	print(value)
	var new_size = Vector2(value[0], value[1])
	get_tree().root.size = new_size
	get_window().move_to_center()

func set_value(value_name := "", value = null) -> void:
	{
		"mode": window_mode_changed,
		"multiplier": window_multiplier_changed,
		"size": window_size_changed,
		"vsync": vsync_changed,
		"drop_shadows": drop_shadows_changed,
		"scaling": scaling_changed,
		"visuals": visuals_changed,
		"palette": null_function,
		"hud_size": hud_style_changed,
		"hud_style": hud_style_changed,
		"frame_limit": frame_limit_changed,
		"window_size": set_window_size
	}[value_name].call(value)
