extends State

var _special_entries: Array


func _ready() -> void:
	_connect_special_event_signals()


func on_enter() -> void:
	_connect_signals()
	GameState.player_can_act = false
	obj.edge_areas.set_is_active_on_all_edges(false)
	obj.text_box.queue_entries(_special_entries)


func on_exit() -> void:
	_disconnect_signals()


func run(_delta: float) -> void:
	pass


func _connect_special_event_signals() -> void:
	GameState.fox_met_bear.connect(_on_game_state_special_event)
	GameState.fox_met_self.connect(_on_game_state_special_event)
	GameState.fox_met_stranger.connect(_on_game_state_special_event)
	GameState.fox_found_bullet.connect(_on_game_state_special_event)
	GameState.met_squirrel.connect(_on_game_state_special_event)
	GameState.squirrel_gave_key.connect(_on_game_state_special_event)


func _connect_signals() -> void:
	obj.text_box.new_entries_queued.connect(_on_text_box_new_entries_queued)


func _disconnect_signals() -> void:
	obj.text_box.new_entries_queued.disconnect(_on_text_box_new_entries_queued)


func _on_game_state_special_event(entries: Array) -> void:
	_special_entries = entries
	fsm.transition_to_state(fsm.states.SpecialEvent)


func _on_text_box_new_entries_queued() -> void:
	fsm.transition_to_state(fsm.states.ActionResult)
