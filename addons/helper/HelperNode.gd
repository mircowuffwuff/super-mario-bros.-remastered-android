@tool
extends Control

var keys := []
var locale_files := []

func update_locale_keys() -> void:
	get_locale_keys()
	get_locale_files()
	for i in locale_files:
		update_locale_file_keys(i)
	print("Done")

func get_locale_keys() -> void:
	var file = FileAccess.open("res://Assets/Locale/en.json", FileAccess.READ).get_as_text()
	keys = JSON.parse_string(file).keys()

func get_locale_files() -> void:
	for i in DirAccess.get_files_at("res://Assets/Locale/"):
		if i.get_extension() == "json":
			locale_files.append(i)

func update_locale_file_keys(file_name := "") -> void:
	var new_json := {}
	var json: Dictionary = JSON.parse_string(FileAccess.open("res://Assets/Locale/" + file_name, FileAccess.READ).get_as_text())
	for i in keys:
		if json.has(i) == false:
			new_json.set(i, "")
			print(i)
		else:
			new_json.set(i, json[i])
	var file = FileAccess.open("res://Assets/Locale/" + file_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(new_json, "\t", false))
	file.close()

func remove_tile_signals() -> void:
	var scenes := []
	var base_path := "res://Scenes/Levels/"
	for campaign in ["SMB1", "SMBANN", "SMBLL", "SMBS"]:
		scenes.append_array(get_directories(base_path + campaign))
	for scene in scenes:
		var file = FileAccess.open(scene, FileAccess.READ).get_as_text()
		var lines = file.split("\n", false)
		var idx := 0
		var new_string = ""
		for line in lines:
			if line.contains("connection signal=") and line.contains("Tiles/"):
				continue
			new_string += line + "\n"
		file = FileAccess.open(scene, FileAccess.WRITE).store_string(new_string)
	print("Done")

func get_directories(path := "", array_to_use := []) -> Array:
	for i in DirAccess.get_directories_at(path):
		get_directories(path + "/" + i + "/", array_to_use)
	for i in DirAccess.get_files_at(path):
		if i.get_extension() == "tscn":
			array_to_use.append(path + "/" + i)
	return array_to_use

var delta_enabled := false

func update_value(new_text := "") -> void:
	if new_text.length() != 5:
		%ConvertedSubPixelToDecimal.text = ""
		return
	var value := 0.0
	var idx := 0
	value = float(new_text.hex_to_int()) / 4096
	if delta_enabled:
		value *= 60
	%ConvertedSubPixelToDecimal.text = "Converted: " + str(value)

func toggle_delta(toggled := false) -> void:
	delta_enabled = toggled
	update_value(%InitValue.text)
