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
	VOLUME: [],
	TAKE: [HONEY],
	GIVE: [HONEY],
	EAT: [MUSHROOM, HONEY],
	SWITCH: [],
	FIGHT: [BEAR, FOX, STRANGER, SQUIRREL, SNAKE, MAN],
	UNLOCK: [],
}

var headed_direction: Vector2


func set_up_connections(command_line: LineEdit) -> void:
	command_line.entered_command.connect(_on_command_line_entered_command)


func is_command_valid(cmd: String) -> bool:
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
		_:
			emit_signal("executed_action", Scenarios.invalid_command)


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


func _execute_wake_up_command() -> void:
	if GameState.is_tutorial:
		emit_signal("entered_first_command")
	GameState.reset_after_death()


func _on_command_line_entered_command(cmd: String) -> void:
	if is_command_valid(cmd):
		if GameState.is_fox() and not cmd.begins_with(HEAD):
			emit_signal("executed_action", Scenarios.fox_cannot_do)
		else:
			execute_command(cmd)
	else:
		emit_signal("executed_action", Scenarios.invalid_command)
		#emit_signal("entered_invalid_command")
