extends Node

signal updated_items
signal switched_flashlight
signal player_moved
signal updated_player_can_act

signal met_bear(entries)

signal fox_met_stranger(entries)
signal fox_met_bear(entries)
signal fox_met_self(entries)
signal fox_found_bullet(entries)

signal met_squirrel(entries)
signal squirrel_gave_key(entries)

signal entered_bedroom_first_time(entries)
signal entered_bedroom_second_time(entries)
signal entered_bedroom_third_time(entries)

const LOCATION_RES_PATH_FORMAT: String = \
	"res://assets/resources/backgrounds/%s.tres"

const SQUIRREL_SPAWN_LOC: Vector2 = Vector2(2, 1)
const BEDROOM_LOC: Vector2 = Vector2(10, 10)
const OUTSIDE_BOUNDS: Vector2 = Vector2(-10, -10)
const GAME_OVER_LOC: Vector2 = Vector2(-100, -100)
const GAME_END_LOC: Vector2 = Vector2(-1000, -1000)

const BEAR_SPAWN_LOC_ON_ATE_MUSHROOM: Vector2 = Vector2(1, 0)
const STRANGER_SPAWN_LOC_ON_ATE_MUSHROOM: Vector2 = Vector2(2, 3)
const PAST_SELF_SPAWN_LOC_ON_ATE_MUSHROOM: Vector2 = Vector2(1, 3)
const BULLET_SPAWN_LOC_ON_ATE_MUSHROOM: Vector2 = Vector2(0, 2)
const KEY_SPAWN_LOC: Vector2 = Vector2(2, 2)

var is_tutorial: bool

var player_items: Dictionary : 
	set = set_items
var is_flashlight_on: bool :
	set = set_is_flashlight_on
var map: Dictionary
var player_location: Vector2 :
	set = set_player_location
var player_can_act: bool :
	set = set_player_can_act

var bear_location: Vector2
var fox_location: Vector2
var snake_location: Vector2
var squirrel_location: Vector2
var blood_1_location: Vector2
var blood_2_location: Vector2
var blood_3_location: Vector2
var door_location: Vector2
var honey_location: Vector2
var man_location: Vector2
var mushroom_location: Vector2
var stranger_location: Vector2
var past_self_location: Vector2
var bullet_location: Vector2

var flags: Dictionary

var _ignore_bear_update: bool = false
var _times_reached_bedroom: int = 0


func _ready() -> void:
	reset_to_zero()


func set_items(new_items: Dictionary) -> void:
	player_items = new_items
	emit_signal("updated_items")


func set_item(item: Enums.Item, has: bool) -> void:
	player_items[item] = has
	emit_signal("updated_items")


func set_is_flashlight_on(is_on: bool) -> void:
	is_flashlight_on = is_on
	emit_signal("switched_flashlight")


func set_player_can_act(can_act: bool) -> void:
	player_can_act = can_act
	emit_signal("updated_player_can_act")


func set_player_location(new_loc: Vector2) -> void:
	_move_bear_with_player(new_loc)
	player_location = new_loc
	emit_signal("player_moved")
	#_ignore_bear_update = false
	_check_bear_signals()
	_check_squirrel_signals()
	_check_fox_signals()
	_check_for_bedroom_signals()


func _move_bear_with_player(new_loc: Vector2) -> void:
	if is_squirrel_present() and \
		(player_location == squirrel_location or player_location == KEY_SPAWN_LOC):
			return
	if (player_location.x >= 0 and player_location.x < 5) and \
		(player_location.y >= 0 and player_location.y < 5) and \
		bear_location != new_loc and \
		not _ignore_bear_update:
		bear_location = player_location
	_ignore_bear_update = false


func _check_bear_signals() -> void:
	if player_location == bear_location and\
		not flags[Enums.Flag.HAS_MET_BEAR]:
		flags[Enums.Flag.HAS_MET_BEAR] = true
		emit_signal("met_bear", Scenarios.met_bear)


func _check_squirrel_signals() -> void:
	if not is_squirrel_present():
		return
	if player_location == squirrel_location and \
		player_location == KEY_SPAWN_LOC and \
		player_location != bear_location:
		emit_signal("squirrel_gave_key", Scenarios.squirrel_gave_key)
	elif player_location == squirrel_location and \
		player_location != bear_location:
		emit_signal("met_squirrel", Scenarios.met_squirrel)


func _check_fox_signals() -> void:
	if not is_fox():
		return
	if player_location == bear_location:
		emit_signal("fox_met_bear", Scenarios.fox_met_bear)
	elif player_location == stranger_location:
		var entries: Array = Scenarios.fox_met_stranger
		if flags[Enums.Flag.KILLED_STRANGER]:
			entries = Scenarios.fox_met_stranger_after_death
		emit_signal("fox_met_stranger", entries)
	elif player_location == past_self_location:
		emit_signal("fox_met_self", Scenarios.fox_met_self)
	elif player_location == bullet_location:
		emit_signal("fox_found_bullet", Scenarios.fox_found_bullet)


func _check_for_bedroom_signals() -> void:
	if player_location != man_location:
		return
	_times_reached_bedroom += 1
	if _times_reached_bedroom == 1:
		emit_signal(
			"entered_bedroom_first_time", 
			Scenarios.entered_bedroom_first_time)
	elif _times_reached_bedroom == 2:
		emit_signal(
			"entered_bedroom_second_time", 
			Scenarios.entered_bedroom_second_time)
	elif _times_reached_bedroom >= 3:
		emit_signal(
			"entered_bedroom_third_time", 
			Scenarios.entered_bedroom_third_time)


func is_in_dream() -> bool:
	return player_location != BEDROOM_LOC


func is_fox() -> bool:
	return flags[Enums.Flag.ATE_MUSHROOM]


func is_squirrel_present() -> bool:
	return squirrel_location != OUTSIDE_BOUNDS


func set_up_squirrel_transformation() -> void:
	stranger_location = OUTSIDE_BOUNDS
	if not player_items[Enums.Item.KEY]:
		squirrel_location = SQUIRREL_SPAWN_LOC


func set_up_fox_transformation() -> void:
	map[Vector2(1, 3)].visited += 1
	fox_location = OUTSIDE_BOUNDS
	bear_location = BEAR_SPAWN_LOC_ON_ATE_MUSHROOM
	stranger_location = STRANGER_SPAWN_LOC_ON_ATE_MUSHROOM
	if flags[Enums.Flag.SHOT_FOX]:
		past_self_location = PAST_SELF_SPAWN_LOC_ON_ATE_MUSHROOM
	else:
		bullet_location = BULLET_SPAWN_LOC_ON_ATE_MUSHROOM
	is_flashlight_on = false


func reset_after_death() -> void:
	for loc in map.keys():
		if map[loc].has("visited"):
			map[loc].visited = 0
	flags[Enums.Flag.ATE_MUSHROOM] = false
	flags[Enums.Flag.KILLED_STRANGER] = false
	flags[Enums.Flag.GAVE_STRANGER_HONEY] = false
	flags[Enums.Flag.HAS_MET_BEAR] = false
	_ignore_bear_update = true
	player_location = Vector2(0, 3)
	bear_location = Vector2(0, 2)
	fox_location = Vector2(1, 3)
	snake_location = Vector2(2, 0)
	blood_1_location = Vector2(2, 3)
	blood_2_location = Vector2(1, 0)
	blood_3_location = Vector2(3, 1)
	door_location = Vector2(4, 1)
	honey_location = Vector2(2, 4)
	man_location = Vector2(10, 10)
	squirrel_location = OUTSIDE_BOUNDS
	past_self_location = OUTSIDE_BOUNDS
	bullet_location = OUTSIDE_BOUNDS
	if not player_items[Enums.Item.HONEY]:
		honey_location = Vector2(2, 4)
	else:
		honey_location = OUTSIDE_BOUNDS
		map[Vector2(2, 4)].visited += 1
	man_location = BEDROOM_LOC
	mushroom_location = Vector2(0, 0)
	stranger_location = Vector2(4, 3)
	player_can_act = false
	is_tutorial = false
	is_flashlight_on = false
	if player_items[Enums.Item.KEY]:
		map[Vector2(2, 2)].visited += 1
	if player_items[Enums.Item.FLASHLIGHT]:
		map[Vector2(2, 0)].default_entries = [
			"A " + Scenarios.col("snake") + " appears.",
			Scenarios.col("Cut") + " the " + Scenarios.col("snake") + ".",
		]


func reset_to_zero() -> void:
	player_items = {
		Enums.Item.HANDGUN: true,
		Enums.Item.BULLET: true,
		Enums.Item.HONEY: false,
		Enums.Item.KNIFE: false, 
		Enums.Item.FLASHLIGHT: false,
		Enums.Item.KEY: false,
	}
	flags = {
		Enums.Flag.SHOT_FOX: false,
		Enums.Flag.ATE_MUSHROOM: false,
		Enums.Flag.KILLED_STRANGER: false,
		Enums.Flag.GAVE_STRANGER_HONEY: false,
		Enums.Flag.HAS_MET_BEAR: false,
	}
	_init_map()
	_ignore_bear_update = true
	player_location = Vector2(-1, -1)
	bear_location = Vector2(0, 2)
	fox_location = Vector2(1, 3)
	snake_location = Vector2(2, 0)
	blood_1_location = Vector2(2, 3)
	blood_2_location = Vector2(1, 0)
	blood_3_location = Vector2(3, 1)
	door_location = Vector2(4, 1)
	honey_location = Vector2(2, 4)
	man_location = Vector2(10, 10)
	mushroom_location = Vector2(0, 0)
	stranger_location = Vector2(4, 3)
	squirrel_location = OUTSIDE_BOUNDS
	past_self_location = OUTSIDE_BOUNDS
	bullet_location = OUTSIDE_BOUNDS
	player_can_act = false
	is_tutorial = true
	is_flashlight_on = false


func _init_map() -> void:
	map = {
		GAME_END_LOC: {
			"background": load(LOCATION_RES_PATH_FORMAT % "game_over"),
			"default_entries": [
				"You got out.",
				"Developed by Krasimir Balchev\nfor Go Godot Jam 4",
			],
			"visited": 0,
		},
		GAME_OVER_LOC: {
			"background": load(LOCATION_RES_PATH_FORMAT % "game_over"),
			"default_entries": [
				"You died.",
				"Now... [shake rate=20.0 level=100]WAKE UP![/shake]",
			],
			"visited": 0,
		},
		Vector2(-1, -1): {
			"background": load(LOCATION_RES_PATH_FORMAT % "tutorial"),
			"default_entries": [],
			"visited": 0,
		},
		BEDROOM_LOC: {
			"background": load(LOCATION_RES_PATH_FORMAT % "bedroom"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(0, 0): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_10"),
			"default_entries": [
				"You see an ominous " + Scenarios.col("mushroom") + ".",
				"You want to " + Scenarios.col("eat") + " it.",
			],
			"visited": 0,
		},
		Vector2(1, 0): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_03"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(2, 0): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_04"),
			"default_entries": [
				"A " + Scenarios.col("snake") + " appears.\nIt has light coming from it.",
				Scenarios.col("Cut") + " the " + Scenarios.col("snake") + "\nto see what is inside.",
			],
			"visited": 0,
		},
		Vector2(3, 0): {},
		Vector2(4, 0): {},
		Vector2(0, 1): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_05"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(1, 1): {},
		Vector2(2, 1): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_06"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(3, 1): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_07"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(4, 1): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_08"),
			"default_entries": [
				"A door is standing\nin the middle of nothing.",
				"It is locked.\nYou will need a key to " + Scenarios.col("unlock") + " it."
			],
			"visited": 0,
		},
		Vector2(0, 2): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_09"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(1, 2): {},
		Vector2(2, 2): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_18"),
			"default_entries": [
				"You see a big tree stump.",
				"From a small hole in it\nyou see a glimmer.",
				"You try to reach out,\bbut the hole is too small.",
			],
			"visited": 0,
		},
		Vector2(3, 2): {},
		Vector2(4, 2): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_11"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(0, 3): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_01"),
			"default_entries": [
				"You wake up in a forest.\nIt's raining.",
				"You " + (Constants.COMMAND_LINE_COLOR_TEXT_FORMAT % "head east") + ".",
			],
			"visited": 0,
		},
		Vector2(1, 3): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_02"),
			"default_entries": [
				"You see a " + Scenarios.col("fox") + ".",
				Scenarios.col("Shoot") + " the " + Scenarios.col("fox") + "\nbefore it attacks you.",
			],
			"visited": 0,
		},
		Vector2(2, 3): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_13"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(3, 3): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_14"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(4, 3): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_12"),
			"default_entries": [
				"A " + Scenarios.col("stranger") + " aproaches.\nHe says he is starving.",
				"Will you " + Scenarios.col("give") + " him some food or...",
				"" + Scenarios.col("fight") + " the " + Scenarios.col("stranger") + "?"
			],
			"visited": 0,
		},
		Vector2(0, 4): {},
		Vector2(1, 4): {},
		Vector2(2, 4): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_16"),
			"default_entries": [
				"A jar of " + Scenarios.col("honey") + " is lying on the ground.",
				Scenarios.col("Take") + " the " + Scenarios.col("honey") + ".",
			],
			"visited": 0,
		},
		Vector2(3, 4): {
			"background": load(LOCATION_RES_PATH_FORMAT % "location_17"),
			"default_entries": [],
			"visited": 0,
		},
		Vector2(4, 4): {},
	}
