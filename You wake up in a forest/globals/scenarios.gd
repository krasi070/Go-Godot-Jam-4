extends Node

var fox_cannot_do: Array = [
	"You cannot do that as a " + col("fox") + ".",
	Constants.DO_NOTHING,
]

var turn_on_flashlight: Array = [
	"You turned on the " + col("flashlight") + ".",
	Constants.SWITCH,
]

var turn_off_flashlight: Array = [
	"You turned off the " + col("flashlight") + ".",
	Constants.SWITCH,
]

var unlock_door: Array = [
	"You " + col("unlock") + "ed the " + col("door") + ".",
	"You do not see what is\non the other side.",
	"You still enter it.",
	Constants.ENTER_DOOR,
]

var nothing_to_unlock: Array = [
	"There was nothing to " + col("unlock") + ".",
	Constants.DO_NOTHING,
]

var no_key: Array = [
	"You do not have a key.",
	Constants.DO_NOTHING,
]

var take_honey: Array = [
	"You picked up the jar of " + col("honey") + ".",
	Constants.GOT_HONEY,
]

var take_unknown: Array = [
	"You cannot " + col("take") + " that.",
	Constants.DO_NOTHING,
]

var give_unknown: Array = [
	"You cannot " + col("give") + " that.",
	Constants.DO_NOTHING,
]

var eat_unknown: Array = [
	"You cannot " + col("eat") + " that.",
	Constants.DO_NOTHING,
]

var fight_unknown: Array = [
	"You cannot " + col("fight") + " that.",
	Constants.DO_NOTHING,
]

var no_honey: Array = [
	"You do not have " + col("honey") + ".",
	Constants.DO_NOTHING,
]

var eat_honey: Array = [
	"You ate the " + col("honey") + ".",
	Constants.LOST_HONEY,
]

var eat_mushroom: Array = [
	"You " + col("eat") + " the " + col("mushroom") + ".",
	"You start to grow fur.",
	"Your belongings melt into your body.",
	"You turned into...",
	"a fox.",
	Constants.ATE_MUSHROOM,
]

var no_mushroom: Array = [
	"There are no " + col("mushroom") + "s.",
	Constants.DO_NOTHING,
]

var dead_end: Array = [
	"Dead end.",
	Constants.DO_NOTHING,
]

var head_in_bedroom: Array = [
	"Nowhere to " + col("head") + " to.",
	Constants.DO_NOTHING,
]

var give_in_bedroom: Array = [
	"No thanks.",
	Constants.DO_NOTHING,
]

var give_to_no_one: Array = [
	"No one was there to take it.",
	Constants.DO_NOTHING,
]

var head_default: Array = [
	Constants.HEAD_SUCCESS,
]

var shot_with_no_bullet: Array = [
	"No bullets.",
	Constants.DO_NOTHING,
]

var cut_with_no_knife: Array = [
	"No knife.",
	Constants.DO_NOTHING,
]

var shoot_self_in_dream: Array = [
	"You shot yourself.",
	"Thankfully, this is just a dream.",
	Constants.GAME_OVER,
]

var cut_self_in_dream: Array = [
	"You " + col("cut") + " your veins.",
	"Thankfully, this is just a dream.",
	Constants.GAME_OVER,
]

var shoot_self_in_bedroom: Array = [
	Constants.END,
]

var cut_self_in_bedroom: Array = [
	"You are bleeding.",
	"You should " + col("wake up") + " before you\nlose too much blood.",
	Constants.GAME_OVER,
]

var shoot_bear: Array = [
	"You " + col("shoot") + " the " + col("bear") + " and hit it.",
	"That only made it angrier.",
	Constants.LOST_BULLET,
	Constants.GAME_OVER,
]

var fight_bear: Array = [
	"You decide to take on the " + col("bear") + "\nbare handed.",
	"You lost.",
	Constants.GAME_OVER,
]

var cut_bear: Array = [
	"You stab the " + col("bear") + ".",
	"That only made it angrier.",
	Constants.GAME_OVER,
]

var head_with_bear: Array = [
	"The " + col("bear") + " sees your escape attempt.",
	"It only angered it.",
	Constants.GAME_OVER,
]

var give_to_bear: Array = [
	"The " + col("bear") + " takes the jar and leaves.",
	"You satisfied it for now.",
	Constants.LOST_HONEY,
	Constants.BEAR_MOVES,
]

var shoot_fox: Array = [
	"You shot the " + col("fox") + ". It's dead.",
	Constants.LOST_BULLET,
	Constants.FOX_DIES,
]

var fight_fox: Array = [
	"You approach the " + col("fox") + " but it\nnotices you.",
	"It runs of startled.",
	Constants.FOX_MOVES,
]

var cut_fox: Array = [
	"You approach the " + col("fox") + " but it\nnotices you.",
	"It runs of startled.",
	Constants.FOX_MOVES,
]

var head_with_fox: Array = [
	"The " + col("fox") + " notices you and runs away.",
	Constants.FOX_MOVES,
	Constants.HEAD_SUCCESS,
]

var give_to_fox: Array = [
	"You try to give the " + col("honey") + "\nto the " + col("fox") + ".",
	"It notices your presence and runs off.",
	Constants.FOX_MOVES,
]

var shoot_stranger: Array = [
	"You shot the " + col("stranger") + " in the head.",
	"You go to make sure he is dead.",
	"You find a knife and take it.",
	Constants.LOST_BULLET,
	Constants.GOT_KNIFE,
	Constants.STRANGER_DISAPPEARS,
]

var fight_stranger: Array = [
	"You attack the " + col("stranger") + ".",
	"You kill him with your bare hands.",
	Constants.GOT_KNIFE,
	Constants.STRANGER_DISAPPEARS,
]

var cut_stranger: Array = [
	"You attack the " + col("stranger") + " with his knife.",
	"You kill him.",
	Constants.STRANGER_DISAPPEARS,
]

var head_with_stranger: Array = [
	"The " + col("stranger") + " leaves you on your way.",
	Constants.HEAD_SUCCESS,
]

var give_to_stranger: Array = [
	"The " + col("stranger") + " thanks you.",
	"He gives you a knife in return\nand leaves.",
	Constants.STRANGER_MOVES,
	Constants.LOST_HONEY,
	Constants.GOT_KNIFE,
]

var give_to_stranger_with_knife: Array = [
	"The " + col("stranger") + " thanks you.",
	"He hands you a knife\nbut sees you have the same one.",
	"He decides to keep his knife\nand leaves.",
	Constants.STRANGER_MOVES,
	Constants.LOST_HONEY,
]

var shoot_snake: Array = [
	"You " + col("shoot") + " the " + col("snake") + ".",
	"You missed.",
	"The " + col("snake") + " takes advantage of that.",
	Constants.LOST_BULLET,
	Constants.GAME_OVER,
]

var fight_snake: Array = [
	"You attack the " + col("snake") + ".",
	"You cannot even touch it.",
	Constants.GAME_OVER,
]

var cut_snake: Array = [
	"You " + col("cut") + " the " + col("snake") + " in two.",
	"Then in four.",
	"Inside the " + col("snake") + ",\nyou find a flashlight.",
	"Try to " + col("switch") + " it on.",
	Constants.GOT_FLASHLIGHT,
	Constants.SNAKE_DIES,
]

var cut_snake_again: Array = [
	"You " + col("cut") + " the " + col("snake") + " in two.",
	"Then in four.",
	"No flashlight this time.",
	Constants.SNAKE_DIES,
]

var head_with_snake: Array = [
	"The " + col("snake") + " stops you.",
	"There is no way out.",
	Constants.GAME_OVER,
]

var give_to_snake: Array = [
	"The " + col("snake") + " ignores it.",
	"It takes this chance to attack.",
	Constants.GAME_OVER,
]

var shoot_squirrel: Array = [
	"You shot and hit the " + col("squirrel") + ".",
	"That was only possile because\nit trusted you.",
	Constants.LOST_BULLET,
	Constants.SQUIRREL_DISAPPEARS,
]

var fight_squirrel: Array = [
	"You attack and kill the " + col("squirrel") + ".",
	"That was only possile because\nit trusted you.",
	Constants.SQUIRREL_DISAPPEARS,
]

var cut_squirrel: Array = [
	"You stab the " + col("squirrel") + " in the back.",
	"That was only possile because\nit trusted you.",
	Constants.SQUIRREL_DISAPPEARS,
]

var head_with_squirrel: Array = [
	#"The " + col("squirrel") + " is waiting for you there.",
	Constants.HEAD_SUCCESS,
]

var give_to_squirrel: Array = [
	"The " + col("squirrel") + " considers it.",
	"But decides to decline your offer.",
	Constants.DO_NOTHING,
]

var shoot_man: Array = [
	"Did you really think that\nwould work on me?",
	Constants.LOST_BULLET,
	Constants.GAME_OVER,
]

var fight_man: Array = [
	"Nice try.",
	Constants.GAME_OVER,
]

var cut_man: Array = [
	"Did you really think that\nwould work on me?",
	Constants.GAME_OVER,
]

var invalid_command: Array = [
	"Try something else.",
	Constants.DO_NOTHING,
]

var try_to_remember: Array = [
	"Try to " + col("remember") + " what you know.",
	Constants.DO_NOTHING,
]

var shoot_the_unknown: Array = [
	"You cannot " + col("shoot") + " that.",
	Constants.DO_NOTHING,
]

var cut_the_unknown: Array = [
	"You cannot " + col("cut") + " that.",
	Constants.DO_NOTHING,
]

var target_not_present: Array = [
	"Your target is not here.",
	Constants.DO_NOTHING,
]

var help_called: Array = [
	"You called for " + col("help") + ".",
	"But no one came.",
	Constants.DO_NOTHING,
]

var pet_self_human: Array = [
	"You " + col("pet") + " your" + col("self") + ".",
	"You feel a bit better.",
	Constants.DO_NOTHING,
]

var pet_bear: Array = [
	"You try to " + col("pet") + " the " + col("bear") + ".",
	"It tears your arm off.",
	Constants.GAME_OVER,
]

var pet_fox: Array = [
	"You try to " + col("pet") + " the " + col("fox") + ".",
	"It notices you and runs away\nbefore you manager to do it.",
	Constants.GAME_OVER,
]

var pet_stranger: Array = [
	"You " + col("pet") + " the " + col("stranger") + ".",
	"He gets creeped out and runs away.",
	Constants.STRANGER_DISAPPEARS,
]

var pet_squirrel: Array = [
	"You " + col("pet") + " the " + col("squirrel") + ".",
	"It appreciates it.",
	Constants.DO_NOTHING,
]

var pet_snake: Array = [
	"You try to " + col("pet") + " the " + col("snake") + ".",
	"It bites your hand.",
	"You have a bad feeling about this.",
	Constants.GAME_OVER,
]

var pet_man: Array = [
	"I like that.",
]

# Special events
var fox_met_stranger: Array = [
	"You see a familiar " + col("stranger") + ".",
	"He looks frightened.",
	"Before you realise it,\nhis knife is in your belly.",
	Constants.GAME_OVER,
]

var fox_met_stranger_after_death: Array = [
	"You see a familiar " + col("stranger") + ".",
	"Alive, despite you killing him.",
	"He looks frightened.",
	"Before you realise it,\nhis knife is in your belly.",
	Constants.GAME_OVER,
]

var fox_met_bear: Array = [
	"The " + col("bear") + " knows it is you in there.",
	"You didn't stand a chance.",
	Constants.GAME_OVER,
]

var fox_met_self: Array = [
	"This place looks familiar to you.",
	"You catch a faint sight of...",
	"your" + col("self") + ".\nYour human " + col("self") + ".",
	"You hear the pull of a trigger.",
	Constants.GOT_BULLET,
	Constants.GAME_OVER,
]

var fox_found_bullet: Array = [
	"You sniff out a bullet.",
	"It seems the forest\nhas taken a liking to you.",
	Constants.SNIFFED_BULLET,
	Constants.GOT_BULLET,
]

var met_squirrel: Array = [
	"You see a " + col("squirrel") + " with a hat.",
	"It wants you to follow it " + col("south") + ".",
	Constants.MET_SQUIRREL,
]

var squirrel_gave_key: Array = [
	"The " + col("squirrel") + " goes into a\ntiny hole in a tree stump.",
	"It comes out with a key.",
	"It hands you the key with gratitude.",
	Constants.GOT_KEY,
]

var met_bear: Array = [
	"A " + col("bear") + " is towering over you.",
	col("Shoot") + "ing and " + col("fight") + "ing is of no use.",
	Constants.DO_NOTHING,
]

var entered_bedroom_first_time: Array = [
	"You " + col("wake up") + " in your bedroom.\nIt is dark.",
	"You see a " + col("man") + " in front of you.",
	"You see me.",
	Constants.DO_NOTHING,
]

var entered_bedroom_second_time: Array = [
	"You " + col("wake up") + " in your bedroom.\nIt is dark.",
	"The " + col("man") + " in front of you\nis waiting to see your move.",
	"Will you " + col("shoot") + "...",
	col("Cut") + "...",
	"Or maybe even " + col("fight") + "...",
	Constants.DO_NOTHING,
]

var entered_bedroom_third_time: Array = [
	"You " + col("wake up") + " in your bedroom.\nIt is dark.",
	"The " + col("man") + " is waiting.",
	col("Shoot") + "ing him is useless.",
	"You your" + col("self") + " should know\nthat there is only one exit.",
	Constants.DO_NOTHING,
]

func col(to_color: String) -> String:
	return Constants.COMMAND_LINE_COLOR_TEXT_FORMAT % to_color
