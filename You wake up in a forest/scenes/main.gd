extends Node2D

const EVENT_SCENE_PATH_FORMAT: String = "res://scenes/characters/%s.tscn"

@onready var background: Sprite2D = $Background
@onready var items_container: HBoxContainer = $ItemsContainer
@onready var event: Node2D = $Event
@onready var edge_areas: Node2D = $EdgeAreas
@onready var flashlight: PointLight2D = $Flashlight
@onready var rain_particles: CPUParticles2D = $RainParticles
@onready var text_box: RichTextLabel = $TextBox
@onready var hint_text: RichTextLabel = $HintText
@onready var transition_fade: ColorRect = $TransitionFade

@onready var fsm: FiniteStateMachine = \
	FiniteStateMachine.new(self, $States, $States/Tutorial, true)


func _ready() -> void:
	_connect_signals()
	_set_backgrounds()


func _physics_process(delta: float) -> void:
	fsm.run_machine(delta)


func transition_to_location() -> void:
	GameState.player_can_act = false
	transition_fade.fade_out()
	await transition_fade.fade_out_ended
	_set_backgrounds()
	_set_event()
	transition_fade.fade_in()
	await transition_fade.fade_in_ended


func _connect_signals() -> void:
	GameState.player_moved.connect(_on_game_state_player_moved)
	GameState.switched_flashlight.connect(_on_game_state_switched_flashlight)
	CommandInterpreter.executed_action.connect(_on_command_interpreter_executed_action)


func _set_backgrounds() -> void:
	var bg_data: LocationData = GameState.map[GameState.player_location].background
	background.texture = bg_data.texture
	background.self_modulate = bg_data.modulate
	background.position = bg_data.position
	background.sticky_position = bg_data.position
	background.scale = bg_data.scale
	rain_particles.visible = bg_data.is_raining
	if bg_data.is_raining:
		AudioController.play_loop(AudioController.RAIN_LOOP)
	else:
		AudioController.play_loop(AudioController.HUM_LOOP)


func _set_event() -> void:
	for child in event.get_children():
		child.queue_free()
	for child in background.get_children():
		child.queue_free()
	var loc: Vector2 = GameState.player_location
	var instance: Node2D
	match loc:
		GameState.bear_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "bear").instantiate()
		GameState.fox_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "fox").instantiate()
		GameState.stranger_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "stranger").instantiate()
		GameState.snake_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "snake").instantiate()
		GameState.squirrel_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "squirrel").instantiate()
		GameState.blood_1_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "blood_1").instantiate()
		GameState.blood_2_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "blood_2").instantiate()
		GameState.blood_3_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "blood_3").instantiate()
		GameState.mushroom_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "mushroom").instantiate()
		GameState.door_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "door").instantiate()
		GameState.honey_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "honey").instantiate()
#		GameState.man_location:
#			instance = load(EVENT_SCENE_PATH_FORMAT % "man").instantiate()
	if not is_instance_valid(instance):
		if loc == GameState.man_location:
			instance = load(EVENT_SCENE_PATH_FORMAT % "man").instantiate()
			background.add_child(instance)
			instance.scale /= background.scale
		return
	event.add_child(instance)


func _on_game_state_player_moved() -> void:
	transition_to_location()


func _on_game_state_switched_flashlight() -> void:
	flashlight.visible = GameState.is_flashlight_on


func _on_command_interpreter_executed_action(entries: Array) -> void:
	text_box.queue_entries(entries)
