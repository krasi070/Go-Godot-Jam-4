extends State

const TUTORIAL_TEXTS: Array[String] = [
	"Click the left mouse button\nwhen you see ",
	"Move your cursor to the bottom edge\nof the screen.",
]
const TUTORIAL_EDGE_AREA_TEXT: String = \
	"You hear a whisper.\n\"Type [color=#febcb8]wake up[/color] and press Enter.\""


func on_enter() -> void:
	_connect_signals()
	#CommandInterpreter.execute_command("wake up")
	obj.flashlight.visible = true
	_hide_and_disable_ui()
	_set_up_text_box()
	await obj.text_box.finished_entries
	_teach_typing_commands()


func on_exit() -> void:
	_disconnect_signals()
	_show_ui()
	obj.flashlight.visible = false
	obj.text_box.erase_on_finished = true
	obj.edge_areas.set_is_active_on_all_edges(true)


func run(_delta: float) -> void:
	pass


func _connect_signals() -> void:
	CommandInterpreter.entered_first_command.connect(_on_command_inerpreter_entered_first_command)


func _disconnect_signals() -> void:
	CommandInterpreter.entered_first_command.disconnect(_on_command_inerpreter_entered_first_command)


func _hide_and_disable_ui() -> void:
	obj.items_container.hide()
	obj.event.hide()


func _show_ui() -> void:
	obj.items_container.show()
	obj.event.show()


func _set_up_text_box() -> void:
	obj.text_box.erase_on_finished = false
	obj.text_box.queue_entries(TUTORIAL_TEXTS)


func _teach_typing_commands() -> void:
	obj.edge_areas.south_edge.is_active = true
	obj.edge_areas.south_edge.hint_text = TUTORIAL_EDGE_AREA_TEXT
	GameState.player_can_act = true


func _on_command_inerpreter_entered_first_command() -> void:
	await obj.transition_fade.fade_out_ended
	fsm.transition_to_state(fsm.states.Story)
