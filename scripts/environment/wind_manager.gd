@tool
class_name WindManager
extends Node2D

# --- Variables --- #
@export var wind_speed: float = 1.0
var wind_position := 0.0

# --- Functions --- #
func _process(delta):
	wind_position += wind_speed * delta;
	RenderingServer.global_shader_parameter_set('wind_position', wind_position)
