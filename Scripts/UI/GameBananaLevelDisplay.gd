extends Control

const GAME_BANANA_MOD_CONTAINER = preload("uid://bgjgx4nyvg7rf")

func _ready() -> void:
	GameBanana.get_mod_list()
	await GameBanana.list_recieved
	for i in GameBanana.current_list:
		print(i)
		var container: BananaModContainer = GAME_BANANA_MOD_CONTAINER.instantiate()
