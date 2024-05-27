class_name OverworldController
extends CharacterBody2D

# --- Variables --- #
@export var movement_speed: float = 20.0

@export_group("Shaders")
@export var overworld_size: Vector2 = Vector2(480, 270)
@export var position_marker: Node2D

# --- Functions --- #
func _process(delta) -> void:
	velocity = get_input().normalized() * movement_speed
	move_and_slide()
	
	RenderingServer.global_shader_parameter_set('player_position', position_marker.global_position / overworld_size)

func get_input() -> Vector2:
	return Vector2(Input.get_axis('overworld_left', 'overworld_right'), Input.get_axis('overworld_up', 'overworld_down'))
