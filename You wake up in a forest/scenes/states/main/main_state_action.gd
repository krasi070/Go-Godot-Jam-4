extends State


func on_enter() -> void:
	_connect_signals()
	GameState.player_can_act = true
	obj.edge_areas.update_all_edge_areas()
	obj.edge_areas.set_is_active_on_all_edges(true)


func on_exit() -> void:
	_disconnect_signals()
	GameState.player_can_act = false
	obj.edge_areas.set_is_active_on_all_edges(false)


func run(_delta: float) -> void:
	pass


func _connect_signals() -> void:
	GameState.player_moved.connect(_on_game_state_player_moved)
	obj.text_box.new_entries_queued.connect(_on_text_box_new_entries_queued)


func _disconnect_signals() -> void:
	GameState.player_moved.disconnect(_on_game_state_player_moved)
	obj.text_box.new_entries_queued.disconnect(_on_text_box_new_entries_queued)


func _on_game_state_player_moved() -> void:
	await obj.transition_fade.fade_out_ended
	fsm.transition_to_state(fsm.states.Story)


func _on_text_box_new_entries_queued() -> void:
	fsm.transition_to_state(fsm.states.ActionResult)
