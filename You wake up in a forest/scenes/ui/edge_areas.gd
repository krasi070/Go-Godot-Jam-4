extends Node2D

@onready var north_edge: Area2D = $NorthEdgeArea
@onready var east_edge: Area2D = $EastEdgeArea
@onready var south_edge: Area2D = $SouthEdgeArea
@onready var west_edge: Area2D = $WestEdgeArea


func _ready() -> void:
	show()


func set_is_active_on_all_edges(is_active: bool) -> void:
	for edge in get_children():
		edge.is_active = is_active


func update_all_edge_areas() -> void:
	for edge in get_children():
		edge.update_hint_text()
