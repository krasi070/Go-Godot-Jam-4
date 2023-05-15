extends State


func on_enter() -> void:
	GameState.player_can_act = false
	obj.edge_areas.set_is_active_on_all_edges(false)
	GameState.map[GameState.player_location].visited += 1
	var entries: Array = GameState.map[GameState.player_location].default_entries
	if GameState.map[GameState.player_location].visited == 1 and \
		not entries.is_empty():
		obj.text_box.queue_entries(entries)
		await obj.text_box.finished_entries
	fsm.transition_to_state(fsm.states.Action)


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass
