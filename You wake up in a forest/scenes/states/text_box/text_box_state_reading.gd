extends State


func on_enter() -> void:
	if obj.entry_queue.is_empty():
		fsm.transition_to_state(fsm.states.Reading)
	elif obj.entry_queue[0].begins_with("$"):
		obj.emit_signal("received_action_entries", obj.entry_queue.duplicate())
		obj.entry_queue.clear()
		fsm.transition_to_state(fsm.states.Preparation)
	else:
		obj.show()
		obj.visible_characters = 0
		var entry: String = obj.entry_queue.pop_front()
		GameState.set_possible_encountered_keywords(entry)
		if not obj.entry_queue.is_empty() or obj.erase_on_finished:
			entry += obj.TICK_CHARACTER
		obj.text = obj.TEXT_FORMAT % entry
		obj.tween = create_tween()
		obj.tween.finished.connect(_on_tween_finished)
		var char_count: int = obj.get_total_character_count()
		obj.tween.tween_property(
			obj, 
			"visible_characters",
			char_count,
			char_count * obj.CHAR_READ_RATE)


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass


func _on_tween_finished() -> void:
	if fsm.state_curr == fsm.states.Reading:
		fsm.transition_to_state(fsm.states.Finished)
