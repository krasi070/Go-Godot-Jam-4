extends State

var can_proceed = false


func on_enter() -> void:
	can_proceed = true
	if obj.entry_queue.is_empty() and not obj.erase_on_finished:
		fsm.transition_to_state(fsm.states.Preparation)
		obj.emit_signal("finished_entries")


func on_exit() -> void:
	pass


func run(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if not obj.is_active:
		return
	if fsm.state_curr == fsm.states.Finished and \
		event.is_action_pressed("click") and \
		can_proceed:
			AudioController.play_sfx(AudioController.CLICK_SOUND)
			if obj.entry_queue.is_empty():
				fsm.transition_to_state(fsm.states.Preparation)
				# Add slight delay
				#await get_tree().create_timer(0.05).timeout
				obj.emit_signal("finished_entries")
			else:
				fsm.transition_to_state(fsm.states.Reading)
