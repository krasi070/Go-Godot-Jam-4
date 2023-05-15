extends RichTextLabel

const HINT_TEXT_FORMAT: String = "[center]%s[/center]"

@export var item_hint_offset: int = 5
@export var edge_hint_offset: int = 2

var _min_size: Vector2


func _ready() -> void:
	_min_size = custom_minimum_size
	reset_hint_text()
	_connect_signals()


func _connect_signals() -> void:
	EventBus.item_box_hovered.connect(_on_item_box_hovered)
	EventBus.item_box_hover_ended.connect(_on_item_box_hover_ended)
	EventBus.edge_hovered.connect(_on_edge_hovered)
	EventBus.edge_hover_ended.connect(_on_edge_hover_ended)
	GameState.player_moved.connect(_on_game_state_player_moved)


func reset_hint_text() -> void:
	hide()
	text = ""
	custom_minimum_size = _min_size
	size = _min_size


func _on_item_box_hovered(pos: Vector2, item_box_size: Vector2, hint_text: String) -> void:
	text = HINT_TEXT_FORMAT % hint_text
	position = Vector2(
		pos.x - size.x * scale.x / 2 + item_box_size.x / 2,
		pos.y + item_box_size.y + item_hint_offset)
	show()


func _on_item_box_hover_ended() -> void:
	reset_hint_text()


func _on_edge_hovered(pos: Vector2, dir: Vector2, hint_text: String) -> void:
	if dir.x == 0:
		custom_minimum_size = Vector2(_min_size.x * 4, 0)
		size = Vector2(custom_minimum_size.x, size.y)
	text = HINT_TEXT_FORMAT % hint_text
	var half_size: Vector2 = Vector2(size.x, get_minimum_size().y) * scale / 2
	position = \
		pos - half_size - \
		half_size * dir - \
		edge_hint_offset * dir
	show()


func _on_edge_hover_ended() -> void:
	reset_hint_text()


func _on_game_state_player_moved() -> void:
	reset_hint_text()
