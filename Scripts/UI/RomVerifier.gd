class_name ROMVerifier
extends Node

const VALID_HASHES := [
	"6a54024d5abe423b53338c9b418e0c2ffd86fed529556348e52ffca6f9b53b1a",
	"c9b34443c0414f3b91ef496d8cfee9fdd72405d673985afa11fb56732c96152b"
]

# implemented as per https://github.com/SeppNel/Godot-File-Picker/tree/main
var android_picker

func haptic_feedback() -> void:
	Input.vibrate_handheld(3, 0.5)

func _ready() -> void:
	Global.get_node("GameHUD").hide()

	OnScreenControls.should_show = false
	await get_tree().physics_frame
	android_picker = Engine.get_singleton("GodotFilePicker")
	android_picker.file_picked.connect(on_file_selected)

func on_screen_tapped() -> void:
	haptic_feedback()
	android_picker.openFilePicker("*/*")

func on_file_selected(temp_path: String, mime_type: String) -> void:
	handle_rom(temp_path)
	DirAccess.remove_absolute(temp_path)

func handle_rom(path: String) -> bool:
	if path.get_extension() in ["zip", "7z", "rar", "tar", "gz", "gzip", "bz2"]:
		zip_error()
		return false
	if not is_valid_rom(path):
		if path.get_extension() in ["nes", "nez", "fds", "qd", "unf", "unif", "nsf", "nsfe"]:
			error()
		else: extension_error()
		return false
	#Global.rom_path = path # ??????
	Global.rom_path = Global.ROM_PATH
	copy_rom(path)
	verified()
	return true

func copy_rom(file_path: String) -> void:
	DirAccess.copy_absolute(file_path, Global.ROM_PATH)

static func get_hash(file_path: String) -> String:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return ""
	var file_bytes := file.get_buffer(40976)
	var data := file_bytes.slice(16)
	return Marshalls.raw_to_base64(data).sha256_text()

static func is_valid_rom(rom_path := "") -> bool:
	return get_hash(rom_path) in VALID_HASHES


func error() -> void:
	%Error.show()
	%ZipError.hide()
	%ExtensionError.hide()
	$ErrorSFX.play()

func zip_error() -> void:
	%ZipError.show()
	%Error.hide()
	%ExtensionError.hide()
	$ErrorSFX.play()
	
func extension_error() -> void:
	%ExtensionError.show()
	%Error.hide()
	%ZipError.hide()
	$ErrorSFX.play()

func verified() -> void:
	$BGM.queue_free()
	%DefaultText.queue_free()
	%SuccessMSG.show()
	$SuccessSFX.play()
	await get_tree().create_timer(3, false).timeout
	
	var target_scene := "res://Scenes/Levels/TitleScreen.tscn"
	if not Global.rom_assets_exist:
		target_scene = "res://Scenes/Levels/RomResourceGenerator.tscn"
	Global.transition_to_scene(target_scene)

func _exit_tree() -> void:
	Global.get_node("GameHUD").show()
	OnScreenControls.should_show = true
