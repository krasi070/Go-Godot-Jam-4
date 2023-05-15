extends ColorRect

signal fade_out_ended
signal fade_in_ended

const DEFAULT_FADE_DURATION: float = 0.75
const TRANSPARENT_COLOR: Color = Color(0, 0, 0, 0)
const DEFAULT_FADE_COLOR: Color = Color.BLACK

var _tween: Tween


func _ready() -> void:
	color = TRANSPARENT_COLOR


func fade_out(duration: float = DEFAULT_FADE_DURATION, fade_color: Color = DEFAULT_FADE_COLOR) -> void:
	EventBus.emit_signal("transition_started")
	color = TRANSPARENT_COLOR
	if is_instance_valid(_tween):
			return
	_tween = create_tween()
	_tween.tween_property(self, "color", fade_color, duration)
	await _tween.finished
	_tween = null
	emit_signal("fade_out_ended")


func fade_in(duration: float = DEFAULT_FADE_DURATION) -> void:
	if is_instance_valid(_tween):
			return
	_tween = create_tween()
	_tween.tween_property(self, "color", Color(color.r, color.g, color.b, 0), duration)
	await _tween.finished
	_tween = null
	emit_signal("fade_in_ended")
	EventBus.emit_signal("transition_ended")
