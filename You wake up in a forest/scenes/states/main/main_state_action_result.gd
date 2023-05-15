extends State

var _special_entries: Array


func on_enter() -> void:
	_connect_signals()
	GameState.player_can_act = false
	obj.edge_areas.set_is_active_on_all_edges(false)


func on_exit() -> void:
	_disconnect_signals()


func run(_delta: float) -> void:
	pass


func _execute_action(action: String) -> void:
	match action:
		Constants.HEAD_SUCCESS:
			_head_to()
		Constants.GAME_OVER:
			fsm.transition_to_state(fsm.states.Death)
		Constants.END:
			fsm.transition_to_state(fsm.states.End)
		Constants.GOT_KNIFE:
			GameState.set_item(Enums.Item.KNIFE, true)
		Constants.GOT_FLASHLIGHT:
			GameState.set_item(Enums.Item.FLASHLIGHT, true)
		Constants.GOT_HONEY:
			_remove_event()
			GameState.honey_location = GameState.OUTSIDE_BOUNDS
			GameState.set_item(Enums.Item.HONEY, true)
		Constants.GOT_KEY:
			GameState.set_item(Enums.Item.KEY, true)
		Constants.GOT_BULLET:
			GameState.set_item(Enums.Item.BULLET, true)
		Constants.LOST_BULLET:
			GameState.set_item(Enums.Item.BULLET, false)
		Constants.LOST_HONEY:
			GameState.set_item(Enums.Item.HONEY, false)
		Constants.BEAR_MOVES:
			_remove_event()
			GameState.bear_location = GameState.OUTSIDE_BOUNDS
		Constants.FOX_DIES:
			_remove_event()
			GameState.fox_location = GameState.OUTSIDE_BOUNDS
			GameState.flags[Enums.Flag.SHOT_FOX] = true
		Constants.FOX_MOVES:
			_remove_event()
			GameState.fox_location = GameState.OUTSIDE_BOUNDS
		Constants.SNAKE_DIES:
			_remove_event()
			GameState.snake_location = GameState.OUTSIDE_BOUNDS
		Constants.SQUIRREL_DISAPPEARS:
			_remove_event()
			GameState.squirrel_location = GameState.OUTSIDE_BOUNDS
		Constants.STRANGER_DIES:
			_remove_event()
			GameState.stranger_location = GameState.OUTSIDE_BOUNDS
			GameState.flags[Enums.Flag.KILLED_STRANGER] = true
		Constants.STRANGER_MOVES:
			_remove_event()
			GameState.flags[Enums.Flag.GAVE_STRANGER_HONEY] = true
			GameState.set_up_squirrel_transformation()
		Constants.ATE_MUSHROOM:
			_remove_event()
			GameState.flags[Enums.Flag.ATE_MUSHROOM] = true
			GameState.set_up_fox_transformation()
		Constants.SWITCH:
			GameState.is_flashlight_on = not GameState.is_flashlight_on
		Constants.ENTER_DOOR:
			GameState.player_location = GameState.BEDROOM_LOC
		Constants.DO_NOTHING:
			pass
		Constants.MET_SQUIRREL:
			_remove_event()
			GameState.squirrel_location = GameState.KEY_SPAWN_LOC
		Constants.SNIFFED_BULLET:
			GameState.bullet_location = GameState.OUTSIDE_BOUNDS
#		Constants.PLAY_GUNSHOT:
#			AudioController.play_sfx(AudioController.GUNSHOT_SOUND)
		_:
			print("Unknown action! ", action)


func _head_to() -> void:
	var new_loc: Vector2 = GameState.player_location + CommandInterpreter.headed_direction
	GameState.player_location = new_loc


func _remove_event() -> void:
	obj.event.get_child(0).queue_free()


func _connect_signals() -> void:
	GameState.player_moved.connect(_on_game_state_player_moved)
	obj.text_box.received_action_entries.connect(_on_text_box_received_action_entries)
	GameState.fox_met_bear.connect(_on_game_state_special_event)
	GameState.fox_met_self.connect(_on_game_state_special_event)
	GameState.fox_met_stranger.connect(_on_game_state_special_event)
	GameState.fox_found_bullet.connect(_on_game_state_special_event)
	GameState.met_squirrel.connect(_on_game_state_special_event)
	GameState.squirrel_gave_key.connect(_on_game_state_special_event)
	GameState.met_bear.connect(_on_game_state_special_event)
	GameState.entered_bedroom_first_time.connect(_on_game_state_special_event)
	GameState.entered_bedroom_second_time.connect(_on_game_state_special_event)
	GameState.entered_bedroom_third_time.connect(_on_game_state_special_event)


func _disconnect_signals() -> void:
	GameState.player_moved.disconnect(_on_game_state_player_moved)
	obj.text_box.received_action_entries.disconnect(_on_text_box_received_action_entries)
	GameState.fox_met_bear.disconnect(_on_game_state_special_event)
	GameState.fox_met_self.disconnect(_on_game_state_special_event)
	GameState.fox_met_stranger.disconnect(_on_game_state_special_event)
	GameState.fox_found_bullet.disconnect(_on_game_state_special_event)
	GameState.met_squirrel.disconnect(_on_game_state_special_event)
	GameState.squirrel_gave_key.disconnect(_on_game_state_special_event)
	GameState.met_bear.disconnect(_on_game_state_special_event)
	GameState.entered_bedroom_first_time.disconnect(_on_game_state_special_event)
	GameState.entered_bedroom_second_time.disconnect(_on_game_state_special_event)
	GameState.entered_bedroom_third_time.disconnect(_on_game_state_special_event)


func _on_game_state_special_event(entries: Array) -> void:
	_special_entries = entries


func _on_game_state_player_moved() -> void:
	await obj.transition_fade.fade_out_ended
	if _special_entries.is_empty():
		fsm.transition_to_state(fsm.states.Story)
		return
	obj.text_box.queue_entries(_special_entries.duplicate())
	_special_entries = []


func _on_text_box_received_action_entries(entries: Array) -> void:
	var is_last_entry_transition: bool = \
		entries[-1] == Constants.HEAD_SUCCESS or \
		entries[-1] == Constants.GAME_OVER or \
		entries[-1] == Constants.END
	for entry in entries:
		_execute_action(entry)
		obj.edge_areas.update_all_edge_areas()
	if not is_last_entry_transition:
		fsm.transition_to_state(fsm.states.Action)
