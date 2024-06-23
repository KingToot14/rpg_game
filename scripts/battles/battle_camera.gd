class_name BattleCamera
extends Camera2D

# --- Variables --- #
@export var noise: FastNoiseLite
var noise_pos := 0.0

var shake_strength: float

# --- Constants --- #
const SHAKE_SPEED := 60.0

# --- Functions --- #
func _process(delta) -> void:
	noise_pos += SHAKE_SPEED * delta
	
	offset = get_random_offset()

func get_random_offset() -> Vector2:
	return Vector2(noise.get_noise_2d(1  , noise_pos) - 0.5, 
				   noise.get_noise_2d(100, noise_pos) - 0.5) * shake_strength

func do_screen_shake(intensity: float = 10.0, time: float = 0.25) -> void:
	var tween = create_tween()
	
	shake_strength = intensity
	
	# pull from options
	shake_strength *= DataManager.options.screen_shake_intensity
	
	tween.tween_property(self, 'shake_strength', 0, time)
