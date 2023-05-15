extends Node

const GUNSHOT_SOUND: String = "gunshot"
const CLICK_SOUND: String = "click"
const DOOR_OPEN_SOUND: String = "door_open"
const RAIN_LOOP: String = "rain_loop"
const HUM_LOOP: String = "hum_loop"

const RAIN_LOOP_STREAM: AudioStreamMP3 = preload("res://assets/audio/rain_loop.mp3")
const HUM_LOOP_STREAM: AudioStreamMP3 = preload("res://assets/audio/hum_loop.mp3")

const PITCH_RANDOMIZER: Dictionary = {
	CLICK_SOUND: [0.6, 1.4],
	GUNSHOT_SOUND: [1.2, 1.8],
	DOOR_OPEN_SOUND: [0.9, 1.1],
}

@onready var rain_loop_player: AudioStreamPlayer2D = $RainLoopPlayer
@onready var hum_loop_player: AudioStreamPlayer2D = $HumLoopPlayer
@onready var click_player: AudioStreamPlayer2D = $ClickPlayer
@onready var gunshot_player: AudioStreamPlayer2D = $GunshotPlayer
@onready var door_open_player: AudioStreamPlayer2D = $DoorOpenPlayer


func _ready() -> void:
	rain_loop_player.volume_db = -80
	rain_loop_player.play()
	hum_loop_player.volume_db = -80
	rain_loop_player.play()


func play_loop(loop: String) -> void:
	match loop:
		RAIN_LOOP:
			_fade(hum_loop_player, rain_loop_player)
		HUM_LOOP:
			_fade(rain_loop_player, hum_loop_player)


func play_sfx(sfx: String) -> void:
	match sfx:
		GUNSHOT_SOUND:
			_play_player(gunshot_player, PITCH_RANDOMIZER[sfx])
		CLICK_SOUND:
			_play_player(click_player, PITCH_RANDOMIZER[sfx])
		DOOR_OPEN_SOUND:
			_play_player(door_open_player, PITCH_RANDOMIZER[sfx])


func _play_player(player: AudioStreamPlayer2D, rand_pitch: Array) -> void:
	player.pitch_scale = randf_range(rand_pitch[0], rand_pitch[1])
	player.play()


func _fade(from: AudioStreamPlayer2D, to: AudioStreamPlayer2D) -> void:
	from.play()
	to.play()
	var tween: Tween = create_tween()
	tween.tween_property(from, "volume_db", -80.0, 0.75)
	tween.parallel().tween_property(to, "volume_db", 0.0, 0.75)
	await tween.finished
	from.stop()
	
