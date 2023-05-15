extends Sprite2D

const CENTER: Vector2 = Vector2(144, 108)

var move_with_mouse_multiplier: Vector2 = Vector2(-0.006, -0.006)
var sticky_position: Vector2


func _ready() -> void:
	sticky_position = position


func _process(_delta: float) -> void:
	_handle_move_with_mouse()


func _handle_move_with_mouse() -> void:
	var mouse_pos_centered = get_global_mouse_position() - CENTER
	position = sticky_position + mouse_pos_centered * move_with_mouse_multiplier
