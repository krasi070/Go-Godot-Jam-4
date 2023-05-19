extends Area2D

const DIRECTION_STR: Dictionary = {
	Vector2.UP: "north",
	Vector2.DOWN: "south",
	Vector2.RIGHT: "east",
	Vector2.LEFT: "west",
}

const HINT_TEXT_FORMAT: String = "[center]%s[/center]"
const DEAD_END_TEXT: String = "The silence of a dead end deafens you."
const DEFAULT_TEXT: String = "You sense no danger."
const BEAR_TEXT: String = "A beast is searching for you."
const STRANGER_TEXT: String = "Someone is there."
const SNAKE_TEXT: String = "You hear hissing."
const SQUIRREL_TEXT: String = "You hear a critter trying to hide."
const BLOOD_TEXT: String = "You smell blood."
const MUSHROOM_TEXT: String = "Something is inviting you."
const FOX_TEXT: String = "Mixed feelings swell up in your chest."
const DOOR_TEXT: String = "You spot something weird."
const HONEY_TEXT: String = "A sweet smell lingers."
const BULLET_TEXT: String = "You sniff faint traces of metal."

@export var direction: Vector2
@export_multiline var hint_text: String
@export var is_active: bool = false :
	set = _set_is_active

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var _is_hovered: bool = false


func _ready() -> void:
	_connect_signals()


func update_hint_text() -> void:
	var next_hint_text: String = \
		(Constants.COMMAND_LINE_COLOR_TEXT_FORMAT + "\n") % DIRECTION_STR[direction]
	var next_loc: Vector2 = GameState.player_location + direction
	if not GameState.map.has(next_loc) or GameState.map[next_loc].is_empty():
		next_hint_text += DEAD_END_TEXT
	elif next_loc == GameState.bear_location:
		next_hint_text += BEAR_TEXT
	elif next_loc == GameState.fox_location or \
		next_loc == GameState.past_self_location:
		next_hint_text += FOX_TEXT
	elif next_loc == GameState.stranger_location:
		next_hint_text += STRANGER_TEXT
	elif next_loc == GameState.snake_location:
		next_hint_text += SNAKE_TEXT
	elif next_loc == GameState.squirrel_location:
		next_hint_text += SQUIRREL_TEXT
	elif next_loc == GameState.blood_1_location or \
		next_loc == GameState.blood_2_location or \
		next_loc == GameState.blood_3_location:
		next_hint_text += BLOOD_TEXT
	elif next_loc == GameState.mushroom_location:
		next_hint_text += MUSHROOM_TEXT
	elif next_loc == GameState.door_location:
		next_hint_text += DOOR_TEXT
	elif next_loc == GameState.honey_location:
		next_hint_text += HONEY_TEXT
	elif next_loc == GameState.bullet_location:
		next_hint_text += BULLET_TEXT
	else:
		next_hint_text += DEFAULT_TEXT
	hint_text = HINT_TEXT_FORMAT % next_hint_text


func _set_is_active(_is_active: bool) -> void:
	is_active = _is_active
	if not is_active and _is_hovered:
		EventBus.emit_signal("edge_hover_ended")


func _connect_signals() -> void:
	mouse_entered.connect(_on_edge_area_mouse_entered)
	mouse_exited.connect(_on_edge_area_mouse_exited)
	GameState.player_moved.connect(_on_game_state_player_moved)


func _on_edge_area_mouse_entered() -> void:
	if not is_active:
		return
	_is_hovered = true
	EventBus.emit_signal(
		"edge_hovered", 
		collision_shape.global_position,
		direction,
		hint_text)


func _on_edge_area_mouse_exited() -> void:
	if not is_active:
		return
	_is_hovered = false
	EventBus.emit_signal("edge_hover_ended")


func _on_game_state_player_moved() -> void:
	update_hint_text()
