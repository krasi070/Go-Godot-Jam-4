extends Label


func _ready() -> void:
	_connect_signals()
	hide()


func _connect_signals() -> void:
	EventBus.transition_started.connect(_on_transition_started)
	EventBus.transition_ended.connect(_on_transition_ended)


func _on_transition_started() -> void:
	hide()


func _on_transition_ended() -> void:
	show()
