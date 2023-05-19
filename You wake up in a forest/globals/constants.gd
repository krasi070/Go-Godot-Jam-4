extends Node

const ITEM_TEXTURES: Dictionary = {
	Enums.Item.HANDGUN: preload("res://assets/sprites/items/handgun.png"),
	Enums.Item.BULLET: preload("res://assets/sprites/items/bullet.png"),
	Enums.Item.HONEY: preload("res://assets/sprites/items/honey.png"),
	Enums.Item.KNIFE: preload("res://assets/sprites/items/knife.png"), 
	Enums.Item.FLASHLIGHT: preload("res://assets/sprites/items/flashlight.png"),
	Enums.Item.KEY: preload("res://assets/sprites/items/key.png"),
}

const START_COMMAND_LINE_COLOR_TAG: String = "[color=#febcb8]"
const END_COMMAND_LINE_COLOR_TAG: String = "[/color]"
const COMMAND_LINE_COLOR_TEXT_FORMAT: String = \
	START_COMMAND_LINE_COLOR_TAG + "%s" + END_COMMAND_LINE_COLOR_TAG
const KEYWORD_REGEX: String = "\\[color=#febcb8\\]([A-Za-z]+\\s*)+\\[\\/color\\]"
const TEXTBOX_LETTER_LIMIT_PER_LINE: int = 30

const GAME_OVER: String = "$game over"
const END: String = "$end"
const GOT_KNIFE: String = "$knife"
const GOT_FLASHLIGHT: String = "$flashlight"
const GOT_HONEY: String = "$honey"
const GOT_KEY: String = "$key"
const GOT_BULLET: String = "$bullet"
const LOST_BULLET: String = "$lost bullet"
const LOST_HONEY: String = "$lost honey"
const BEAR_MOVES: String = "$bear moves"
const FOX_DIES: String = "$fox dies"
const FOX_MOVES: String = "$fox moves"
const SNAKE_DIES: String = "$snake dies"
const SQUIRREL_DISAPPEARS: String = "$squirrel disappears"
const STRANGER_DISAPPEARS: String = "$stranger dies"
const STRANGER_MOVES: String = "$stranger moves"
const HEAD_SUCCESS: String = "$head"
const ATE_MUSHROOM: String = "$ate mushroom"
const SWITCH: String = "$switch"
const ENTER_DOOR: String = "$enter door"
const DO_NOTHING: String = "$do nothing"
const MET_SQUIRREL: String = "$met squirrel"
const SNIFFED_BULLET: String = "$sniffed bullet"
const PLAY_GUNSHOT: String = "$play gunshot"
