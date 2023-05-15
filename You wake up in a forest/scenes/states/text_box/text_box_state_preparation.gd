extends State


func on_enter() -> void:
	if obj.erase_on_finished:
		obj.reset()


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	if not obj.entry_queue.is_empty():
		obj.emit_signal("new_entries_queued")
		fsm.transition_to_state(fsm.states.Reading)
