extends HBoxContainer

@onready var items: Dictionary = {
	Enums.Item.HANDGUN: $HandgunItemBox,
	Enums.Item.BULLET: $HandgunItemBox,
	Enums.Item.HONEY: $HoneyItemBox,
	Enums.Item.KNIFE: $KnifeItemBox,
	Enums.Item.FLASHLIGHT: $FlashlightItemBox,
	Enums.Item.KEY: $KeyItemBox,
}


func _ready() -> void:
	_on_game_state_updated_items()
	_connect_signals()


func _connect_signals() -> void:
	GameState.updated_items.connect(_on_game_state_updated_items)


func _on_game_state_updated_items() -> void:
	print("here")
	for item in items.keys():
		items[item].textures.clear()
	for item in GameState.player_items.keys():
		if GameState.player_items[item]:
			items[item].textures.append(Constants.ITEM_TEXTURES[item])
		items[item].update_textures()
