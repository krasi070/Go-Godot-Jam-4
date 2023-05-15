extends State


func on_enter() -> void:
	GameState.player_can_act = false
	obj.edge_areas.set_is_active_on_all_edges(false)
	GameState.player_location = GameState.GAME_END_LOC
	await obj.transition_fade.fade_out_ended
	obj.flashlight.visible = true
	obj.items_container.hide()
	var entries: Array = GameState.map[GameState.GAME_END_LOC].default_entries
	obj.text_box.queue_entries(entries)
	await obj.text_box.finished_entries
	GameState.reset_to_zero()
	await obj.transition_fade.fade_out_ended
	fsm.transition_to_state(fsm.states.Tutorial)


func on_exit() -> void:
	obj.flashlight.visible = false
	obj.items_container.show()


func run(_delta: float) -> void:
	pass
