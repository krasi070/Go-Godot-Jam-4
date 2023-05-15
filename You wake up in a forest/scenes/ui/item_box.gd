extends ColorRect

const ITEM_BOX_MATERIAL: Material = \
	preload("res://assets/resources/materials/item_box_material.tres")

const ROTATION_ON_HOVER: float = 5

@export var textures: Array[Texture]
@export var item_types: Array[Enums.Item]
@export_multiline var hint_texts: Array[String]

@onready var foreground: ColorRect = $ItemBoxForeground


func _ready() -> void:
	_connect_signals()
	update_textures()


func update_textures() -> void:
	_remove_textures()
	_set_textures()
	_set_visibility()


func _connect_signals() -> void:
	foreground.mouse_entered.connect(_on_item_box_mouse_entered)
	foreground.mouse_exited.connect(_on_item_box_mouse_exited)


func _set_visibility() -> void:
	for item in item_types:
		if GameState.player_items[item]:
			visible = true
			return
	visible = false


func _remove_textures() -> void:
	for child in foreground.get_children():
		child.queue_free()


func _set_textures() -> void:
	for texture in textures:
		var texture_rect: TextureRect = TextureRect.new()
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.texture = texture
		texture_rect.size = foreground.size
		foreground.add_child(texture_rect)


func _on_item_box_mouse_entered() -> void:
	foreground.rotation = deg_to_rad(ROTATION_ON_HOVER)
	for texture_rect in foreground.get_children():
		texture_rect.material = ITEM_BOX_MATERIAL
	EventBus.emit_signal(
		"item_box_hovered", 
		foreground.global_position,
		foreground.size,
		hint_texts[foreground.get_child_count() - 1])


func _on_item_box_mouse_exited() -> void:
	foreground.rotation = 0
	for texture_rect in foreground.get_children():
		texture_rect.material = null
	EventBus.emit_signal("item_box_hover_ended")
