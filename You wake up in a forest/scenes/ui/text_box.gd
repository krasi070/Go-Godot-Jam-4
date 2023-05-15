extends RichTextLabel

signal finished_entries
signal new_entries_queued
signal received_action_entries(entries)

const CHAR_READ_RATE: float = 0.03
#const CHAR_READ_RATE: float = 0.0
const TICK_CHARACTER: String = "[shake rate=8.0 level=60]>[/shake]"
const TEXT_FORMAT: String = "[center]%s[/center]"

var tween: Tween
var entry_queue: Array[String]
var erase_on_finished: bool = true :
	set = set_erase_on_finished
var is_active: bool = true

@onready var fsm: FiniteStateMachine = \
	FiniteStateMachine.new(self, $States, $States/Preparation, true)


func _physics_process(delta: float) -> void:
	fsm.run_machine(delta)


func queue_entry(entry: String) -> void:
	entry_queue.append(entry)


func queue_entries(entries: Array) -> void:
	for entry in entries:
		queue_entry(entry)


func set_erase_on_finished(_erase_on_finished: bool) -> void:
	erase_on_finished = _erase_on_finished
	if erase_on_finished:
		reset()


func reset() -> void:
	hide()
	text = ""
