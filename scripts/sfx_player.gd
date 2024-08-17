class_name SfxPlayer
extends AudioStreamPlayer

# --- Variables --- #
var default_volume: float

# --- Functions --- #
func _ready() -> void:
	default_volume = volume_db

func play_sfx(sfx: AudioStream, volume_modifier := 0.0) -> void:
	volume_db = default_volume + volume_modifier
	stream = sfx
	play()
