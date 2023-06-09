extends Node

signal entered_invalid_command
signal entered_first_command
signal executed_action(entries)

const WAKE: String = "wake"
const SHOOT: String = "shoot"
const CUT: String = "cut"
const HEAD: String = "head"
const PAUSE: String = "pause"
const VOLUME: String = "volume"
const THROW: String = "throw"
const TAKE: String = "take"
const GIVE: String = "give"
const EAT: String = "eat"
const SWITCH: String = "switch"
const FIGHT: String = "fight"
const UNLOCK: String = "unlock"
const HELP: String = "help"
const PET: String = "pet"
const HELLO: String = "hello"
const REMEMBER: String = "remember"

const BEAR: String = "bear"
const STRANGER: String = "stranger"
const MAN: String = "man"
const SELF: String = "self"
const FOX: String = "fox"
const SQUIRREL: String = "squirrel"
const SNAKE: String = "snake"
const NORTH: String = "north"
const SOUTH: String = "south"
const EAST: String = "east"
const WEST: String = "west"
const KEY: String = "key"
const HONEY: String = "honey"
const MUSHROOM: String = "mushroom"
const UP: String = "up"

const COMMAND_LIST: Dictionary = {
	WAKE: [UP],
	SHOOT: [SELF, BEAR, FOX, STRANGER, SQUIRREL, SNAKE, MAN],
	CUT: [SELF, BEAR, FOX, STRANGER, SQUIRREL, SNAKE, MAN],
	HEAD: [NORTH, EAST, SOUTH, WEST],
	PAUSE: [],
	TAKE: [HONEY],
	GIVE: [HONEY],
	EAT: [MUSHROOM, HONEY],
	SWITCH: [],
	FIGHT: [BEAR, FOX, STRANGER, SQUIRREL, SNAKE, MAN],
	UNLOCK: [],
	HELP: [],
	PET: [SELF, BEAR, FOX, STRANGER, SQUIRREL, SNAKE, MAN],
	REMEMBER: [],
}

const SECONDARY_WORDS: Dictionary = {
	"go": HEAD,
	"up": NORTH,
	"right": EAST,
	"down": SOUTH,
	"left": WEST,
	"grab": TAKE,
	"pick": TAKE,
	"pick up": TAKE,
	"myself": SELF,
	"help me": HELP,
	"me": SELF,
	"stab": CUT,
	"use knife": CUT,
	"use gun": SHOOT,
	"unlock door": UNLOCK,
	"use flashlight": SWITCH,
	"hi": HELLO,
	"say hello": HELLO,
	"say hi": HELLO,
	"remind": REMEMBER,
	"recall": REMEMBER,
	"use honey": GIVE + " " + HONEY,
}

const IGNORABLE_SUBSTRINGS: Array = [
	" the",
]

var headed_direction: Vector2


func set_up_connections(command_line: LineEdit) -> void:
	command_line.entered_command.connect(_on_command_line_entered_command)

# Returns the empty string if it is not, and
# the actual command if valid after secondary words are removed:
func is_command_valid(cmd: String) -> String:
	if _check_is_valid(cmd):
		return cmd
	cmd = _remove_ignorable_substrings(cmd)
	cmd = _replace_secondary_words(cmd)
	if _check_is_valid(cmd):
		return cmd
	cmd = _add_context_word(cmd)
	if _check_is_valid(cmd):
		return cmd
	return ""


func execute_command(cmd: String) -> void:
	var cmd_args: PackedStringArray = cmd.split(" ", false)
	if GameState.is_tutorial and cmd_args[0] != WAKE:
		return
	match cmd_args[0]:
		SHOOT:
			_execute_shoot_command(cmd_args[1])
		CUT:
			_execute_cut_command(cmd_args[1])
		HEAD:
			_execute_head_command(cmd_args[1])
		TAKE:
			_execute_take_command(cmd_args[1])
		GIVE:
			_execute_give_command(cmd_args[1])
		EAT:
			_execute_eat_command(cmd_args[1])
		SWITCH:
			_execute_switch_command()
		UNLOCK:
			_execute_unlock_command()
		FIGHT:
			_execute_fight_command(cmd_args[1])
		WAKE:
			_execute_wake_up_command()
		HELP:
			_execute_help_command()
		PET:
			_execute_pet_command(cmd_args[1])
		REMEMBER:
			_execute_remember_command()
		_:
			emit_signal("executed_action", Scenarios.invalid_command)


func _check_is_valid(cmd: String) -> bool:
	var cmd_args: PackedStringArray = cmd.split(" ", false)
	if cmd_args.is_empty() or cmd_args.size() > 2:
		return false
	if not COMMAND_LIST.keys().has(cmd_args[0]):
		return false
	if cmd_args.size() == 2 and not COMMAND_LIST[cmd_args[0]].has(cmd_args[1]):
		return false
	if cmd_args.size() == 1 and not COMMAND_LIST[cmd_args[0]].is_empty():
		return false
	return true


func _remove_ignorable_substrings(cmd: String) -> String:
	for substr in IGNORABLE_SUBSTRINGS:
		cmd = cmd.replace(substr, "")
	return cmd


func _replace_secondary_words(cmd: String) -> String:
	for sec_word in SECONDARY_WORDS:
		cmd = cmd.replace(sec_word, SECONDARY_WORDS[sec_word])
	return cmd


func _add_context_word(cmd: String) -> String:
	match GameState.player_location:
		GameState.bear_location:
			cmd += " " + BEAR
		GameState.fox_location:
			cmd += " " + FOX
		GameState.snake_location:
			cmd += " " + SNAKE
		GameState.squirrel_location:
			cmd += " " + SQUIRREL
		GameState.man_location:
			cmd += " " + MAN
		GameState.mushroom_location:
			cmd += " " + MUSHROOM
		GameState.honey_location:
			cmd += " " + HONEY
		GameState.stranger_location:
			cmd += " " + STRANGER
	return cmd


func _execute_remember_command() -> void:
	var entries: Array = []
	var verbs_start: String = "You " + Scenarios.col("remember") + " the verbs you've\nencountered so far."
	entries.append(verbs_start)
	var verb_entries: Array = _construct_keyword_entries(GameState.encountered_keywords.verbs)
	entries.append_array(verb_entries)
	var targets_start: String = "You " + Scenarios.col("remember") + " the targets you've\nencountered so far."
	entries.append(targets_start)
	var target_entries: Array = _construct_keyword_entries(GameState.encountered_keywords.targets)
	entries.append_array(target_entries)
	entries.append(Constants.DO_NOTHING)
	emit_signal("executed_action", entries)


func _construct_keyword_entries(keywords: Dictionary) -> Array:
	var entries: Array = []
	var separator: String = ", "
	var continue_sep: String = ", ..."
	var entry_end_symbol: String = "$$"
	var str_line_one: String = ""
	var str_line_two: String = ""
	var whole_str: String = ""
	for word in keywords.keys():
		var word_len: int = len(keywords[word].text)
		if keywords[word].encountered:
			if not str_line_one.ends_with("\n") and \
				len(str_line_one) + word_len + len(separator) <= Constants.TEXTBOX_LETTER_LIMIT_PER_LINE:
				str_line_one += keywords[word].text + separator
			elif len(str_line_two) + word_len + len(continue_sep) <= Constants.TEXTBOX_LETTER_LIMIT_PER_LINE:
				if not str_line_one.ends_with("\n"):
					str_line_one = str_line_one.trim_suffix(" ") + "\n"
				str_line_two += keywords[word].text + separator
			else:
				str_line_two = str_line_two.trim_suffix(separator) + continue_sep
				whole_str += str_line_one + str_line_two + entry_end_symbol
				str_line_one = keywords[word].text + separator
				str_line_two = ""
	if not str_line_two.is_empty():
		str_line_two = str_line_two.trim_suffix(separator) + continue_sep
		whole_str += str_line_one + str_line_two
	elif not str_line_one.is_empty():
		str_line_one = str_line_one.trim_suffix(separator) + continue_sep
		whole_str += str_line_one
	whole_str = whole_str.trim_suffix(entry_end_symbol)
	whole_str = whole_str.trim_suffix(continue_sep) + "."
	whole_str = _capitalize_first_letter(whole_str)
	for word in keywords.keys():
		if keywords[word].encountered:
			var to_replace: String = keywords[word].text
			if whole_str.begins_with(_capitalize_first_letter(keywords[word].text)):
				to_replace = _capitalize_first_letter(keywords[word].text)
			whole_str = whole_str.replace(
				to_replace, 
				Constants.COMMAND_LINE_COLOR_TEXT_FORMAT % to_replace)
	entries.append_array(whole_str.split(entry_end_symbol, false))
	return entries


func _capitalize_first_letter(_str: String) -> String:
	for i in range(97, 124):
		if _str[0] == String.chr(i):
			_str = _str.trim_prefix(_str[0])
			_str = String.chr(i - 32) + _str
			break
	return _str


func _execute_switch_command() -> void:
	var entries: Array
	if GameState.player_items[Enums.Item.FLASHLIGHT]:
		if GameState.is_flashlight_on:
			entries = Scenarios.turn_off_flashlight
		else:
			entries = Scenarios.turn_on_flashlight
	else:
		entries = Scenarios.invalid_command
	emit_signal("executed_action", entries)


func _execute_unlock_command() -> void:
	var entries: Array
	if GameState.player_items[Enums.Item.KEY]:
		if GameState.player_location == GameState.door_location:
			entries = Scenarios.unlock_door
			AudioController.play_sfx(AudioController.DOOR_OPEN_SOUND)
		else:
			entries = Scenarios.nothing_to_unlock
	else:
		entries = Scenarios.no_key
	emit_signal("executed_action", entries)


func _execute_help_command() -> void:
	emit_signal("executed_action", Scenarios.help_called)


func _execute_eat_command(target: String) -> void:
	var entries: Array
	match target:
		HONEY:
			if GameState.player_items[Enums.Item.HONEY]:
				entries = Scenarios.eat_honey
			else:
				entries = Scenarios.no_honey
		MUSHROOM:
			if GameState.player_location == GameState.mushroom_location:
				entries = Scenarios.eat_mushroom
			else:
				entries = Scenarios.no_mushroom
		_:
			entries = Scenarios.eat_unknown
	emit_signal("executed_action", entries)


func _execute_take_command(target: String) -> void:
	var entries: Array
	match target:
		HONEY:
			if GameState.player_location == GameState.honey_location:
				entries = Scenarios.take_honey
			else:
				entries = Scenarios.target_not_present
		_:
			entries = Scenarios.take_unknown
	emit_signal("executed_action", entries)


func _execute_give_command(target: String) -> void:
	var entries: Array
	if target == HONEY:
		if not GameState.player_items[Enums.Item.HONEY]:
			entries = Scenarios.no_honey
		elif not GameState.is_in_dream():
			entries = Scenarios.give_in_bedroom
		elif GameState.player_location == GameState.bear_location:
			entries = Scenarios.give_to_bear
		elif GameState.player_location == GameState.fox_location:
			entries = Scenarios.give_to_fox
		elif GameState.player_location == GameState.stranger_location:
			if GameState.player_items[Enums.Item.KNIFE]:
				entries = Scenarios.give_to_stranger_with_knife
			else:
				entries = Scenarios.give_to_stranger
		elif GameState.player_location == GameState.squirrel_location:
			entries = Scenarios.give_to_squirrel
		elif GameState.player_location == GameState.snake_location:
			entries = Scenarios.give_to_snake
		else:
			entries = Scenarios.give_to_no_one
	else:
		entries = Scenarios.give_unknown
	emit_signal("executed_action", entries)


func _execute_head_command(dir_str: String) -> void:
	var dir: Vector2 = Vector2.ZERO
	match dir_str:
		NORTH:
			dir = Vector2.UP
		SOUTH:
			dir = Vector2.DOWN
		EAST:
			dir = Vector2.RIGHT
		WEST:
			dir = Vector2.LEFT
	headed_direction = dir
	var new_loc: Vector2 = GameState.player_location + dir
	if dir != Vector2.ZERO and \
		(not GameState.map.has(new_loc) or \
		GameState.map[new_loc].is_empty()):
		emit_signal("executed_action", Scenarios.dead_end)
		return
	var entries: Array
	if not GameState.is_in_dream():
		entries = Scenarios.head_in_bedroom
	elif GameState.player_location == GameState.bear_location:
		entries = Scenarios.head_with_bear
	elif GameState.player_location == GameState.fox_location:
		entries = Scenarios.head_with_fox
	elif GameState.player_location == GameState.stranger_location:
		entries = Scenarios.head_with_stranger
	elif GameState.player_location == GameState.squirrel_location:
		entries = Scenarios.head_with_squirrel
	elif GameState.player_location == GameState.snake_location:
		entries = Scenarios.head_with_snake
	else:
		entries = Scenarios.head_default
	print(entries)
	emit_signal("executed_action", entries)


func _execute_shoot_command(target: String) -> void:
	if not GameState.player_items[Enums.Item.BULLET]:
		emit_signal("executed_action", Scenarios.shot_with_no_bullet)
		return
	var entries: Array
	match target:
		SELF:
			if GameState.is_in_dream():
				entries = Scenarios.shoot_self_in_dream
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
			else:
				entries = Scenarios.shoot_self_in_bedroom
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
		BEAR:
			if GameState.player_location == GameState.bear_location:
				entries = Scenarios.shoot_bear
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
			else:
				entries = Scenarios.target_not_present
		FOX:
			if GameState.player_location == GameState.fox_location:
				entries = Scenarios.shoot_fox
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
			else:
				entries = Scenarios.target_not_present
		STRANGER:
			if GameState.player_location == GameState.stranger_location:
				entries = Scenarios.shoot_stranger
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
			else:
				entries = Scenarios.target_not_present
		SQUIRREL:
			if GameState.player_location == GameState.squirrel_location:
				entries = Scenarios.shoot_squirrel
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
			else:
				entries = Scenarios.target_not_present
		SNAKE:
			if GameState.player_location == GameState.snake_location:
				entries = Scenarios.shoot_snake
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
			else:
				entries = Scenarios.target_not_present
		MAN:
			if GameState.player_location == GameState.man_location:
				entries = Scenarios.shoot_man
				AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
			else:
				entries = Scenarios.target_not_present
		_:
			entries = Scenarios.shoot_the_unknown
	if not entries.is_empty():
		emit_signal("executed_action", entries)


func _execute_cut_command(target: String) -> void:
	if not GameState.player_items[Enums.Item.KNIFE]:
		emit_signal("executed_action", Scenarios.cut_with_no_knife)
		return
	var entries: Array
	match target:
		SELF:
			if GameState.is_in_dream():
				entries = Scenarios.cut_self_in_dream
			else:
				entries = Scenarios.cut_self_in_bedroom
		BEAR:
			if GameState.player_location == GameState.bear_location:
				entries = Scenarios.cut_bear
			else:
				entries = Scenarios.target_not_present
		FOX:
			if GameState.player_location == GameState.fox_location:
				entries = Scenarios.cut_fox
			else:
				entries = Scenarios.target_not_present
		STRANGER:
			if GameState.player_location == GameState.stranger_location:
				entries = Scenarios.cut_stranger
			else:
				entries = Scenarios.target_not_present
		SQUIRREL:
			if GameState.player_location == GameState.squirrel_location:
				entries = Scenarios.cut_squirrel
			else:
				entries = Scenarios.target_not_present
		SNAKE:
			if GameState.player_location == GameState.snake_location:
				if GameState.player_items[Enums.Item.FLASHLIGHT]:
					entries = Scenarios.cut_snake_again
				else:
					entries = Scenarios.cut_snake
			else:
				entries = Scenarios.target_not_present
		MAN:
			if GameState.player_location == GameState.man_location:
				entries = Scenarios.cut_man
			else:
				entries = Scenarios.target_not_present
		_:
			entries = Scenarios.cut_the_unknown
	if not entries.is_empty():
		emit_signal("executed_action", entries)


func _execute_fight_command(target: String) -> void:
	var entries: Array
	match target:
		BEAR:
			if GameState.player_location == GameState.bear_location:
				entries = Scenarios.fight_bear
			else:
				entries = Scenarios.target_not_present
		FOX:
			if GameState.player_location == GameState.fox_location:
				entries = Scenarios.fight_fox
			else:
				entries = Scenarios.target_not_present
		STRANGER:
			if GameState.player_location == GameState.stranger_location:
				entries = Scenarios.fight_stranger
			else:
				entries = Scenarios.target_not_present
		SQUIRREL:
			if GameState.player_location == GameState.squirrel_location:
				entries = Scenarios.fight_squirrel
			else:
				entries = Scenarios.target_not_present
		SNAKE:
			if GameState.player_location == GameState.snake_location:
				entries = Scenarios.fight_snake
			else:
				entries = Scenarios.target_not_present
		MAN:
			if GameState.player_location == GameState.man_location:
				entries = Scenarios.fight_man
			else:
				entries = Scenarios.target_not_present
		_:
			entries = Scenarios.fight_unknown
	if not entries.is_empty():
		emit_signal("executed_action", entries)


func _execute_pet_command(target: String) -> void:
	var entries: Array
	match target:
		BEAR:
			if GameState.player_location == GameState.bear_location:
				entries = Scenarios.pet_bear
			else:
				entries = Scenarios.target_not_present
		FOX:
			if GameState.player_location == GameState.fox_location:
				entries = Scenarios.pet_fox
			else:
				entries = Scenarios.target_not_present
		STRANGER:
			if GameState.player_location == GameState.stranger_location:
				entries = Scenarios.pet_stranger
			else:
				entries = Scenarios.target_not_present
		SQUIRREL:
			if GameState.player_location == GameState.squirrel_location:
				entries = Scenarios.pet_squirrel
			else:
				entries = Scenarios.target_not_present
		SNAKE:
			if GameState.player_location == GameState.snake_location:
				entries = Scenarios.pet_snake
			else:
				entries = Scenarios.target_not_present
		MAN:
			if GameState.player_location == GameState.man_location:
				entries = Scenarios.pet_man
			else:
				entries = Scenarios.target_not_present
		SELF:
			entries = Scenarios.pet_self_human
	if not entries.is_empty():
		emit_signal("executed_action", entries)


func _execute_wake_up_command() -> void:
	if GameState.is_tutorial:
		emit_signal("entered_first_command")
	GameState.reset_after_death()


func _on_command_line_entered_command(cmd: String) -> void:
	cmd = is_command_valid(cmd)
	if not cmd.is_empty():
		GameState.inputted_invalid_command = 0
		GameState.set_encountered_keywords(cmd.split(" ", false))
		if GameState.is_fox() and \
			not (cmd.begins_with(HEAD) or cmd.begins_with(WAKE)):
			emit_signal("executed_action", Scenarios.fox_cannot_do)
		else:
			execute_command(cmd)
	elif GameState.is_tutorial:
		return
	else:
		GameState.inputted_invalid_command += 1
		if GameState.inputted_invalid_command > 2:
			emit_signal("executed_action", Scenarios.try_to_remember)
		else:
			emit_signal("executed_action", Scenarios.invalid_command)
		#emit_signal("entered_invalid_command")
