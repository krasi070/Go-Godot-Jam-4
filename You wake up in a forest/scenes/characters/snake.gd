extends Node2D

@onready var flashlight: PointLight2D = $Flashlight


func _ready() -> void:
	flashlight.visible = not GameState.player_items[Enums.Item.FLASHLIGHT]
