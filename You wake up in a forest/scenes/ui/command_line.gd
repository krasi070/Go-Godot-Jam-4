extends LineEdit

signal entered_command(cmd)

@export var regex_pattern: String


func _ready() -> void:
	_connect_signals()
	text = ""


func _input(event: InputEvent) -> void:
	if not GameState.player_can_act:
		return
	if event.is_action_pressed("enter") and not text.is_empty():
		AudioController.play_sfx(AudioController.CLICK_SOUND)
		emit_signal("entered_command", text.trim_suffix(" ").to_lower())
	if event is InputEventKey and \
		event.pressed:
		if _is_character_or_space_key(event.keycode):
			grab_focus()
		else:
			text = ""
			release_focus()


func _connect_signals() -> void:
	CommandInterpreter.set_up_connections(self)
	text_changed.connect(_on_command_line_text_changed)
	GameState.updated_player_can_act.connect(_on_game_state_updated_player_can_act)


func _is_character_or_space_key(key_code: int) -> bool:
	return (key_code >= KEY_A and key_code <= KEY_Z) or \
		key_code == KEY_SPACE or \
		(not text.is_empty() and \
		(key_code == KEY_BACKSPACE or \
		key_code == KEY_UP or \
		key_code == KEY_DOWN or \
		key_code == KEY_RIGHT or \
		key_code == KEY_LEFT))


func _on_game_state_updated_player_can_act() -> void:
	text = ""
	if GameState.player_can_act:
		add_theme_constant_override("caret_width", 10)
	else:
		add_theme_constant_override("caret_width", 0)


func _on_command_line_text_changed(new_text: String) -> void:
	var old_caret_position = caret_column
	var word: String = ""
	var regex: RegEx = RegEx.new()
	regex.compile(regex_pattern)
	for valid_character in regex.search_all(new_text):
		word += valid_character.get_string().to_lower()
	set_text(word)
	caret_column = old_caret_position
