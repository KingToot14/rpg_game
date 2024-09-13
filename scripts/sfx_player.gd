class_name SfxPlayer
extends AudioStreamPlayer

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	if max_polyphony == 1:
		max_polyphony = 10
	
	if not stream or not (stream is AudioStreamPolyphonic):
		stream = AudioStreamPolyphonic.new()

func play_sfx(sfx: AudioStream, volume_modifier := 0.0) -> void:
	if !playing: play()
	
	var playback = get_stream_playback()
	playback.play_stream(sfx, 0, volume_modifier)
