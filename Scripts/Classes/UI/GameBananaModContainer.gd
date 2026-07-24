class_name BananaModContainer
extends Button

var mod_name := ""
var mod_author := ""
var mod_id := 0
var mod_type := GameBanana.Type.RESOURCE_PACK
var mod_thumbnail: Texture = null
var thumbnail_url := ""
var download_url := ""

func _ready() -> void:
	update_visuals()

func update_visuals() -> void:
	%Thumbnail.texture = mod_thumbnail
	%Name.text = Global.sanitize_string(mod_name)
	%Author.text = Global.sanitize_string(mod_author)
	%CharacterIcon.visible = mod_type == GameBanana.Type.CUSTOM_CHARACTER
	%PackIcon.visible = mod_type == GameBanana.Type.RESOURCE_PACK
	$HTTPRequest.request(thumbnail_url)

func on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == HTTPClient.RESPONSE_OK:
		print(body.get_string_from_utf8())
