class_name OverworldController
extends CharacterBody2D

# --- Variables --- #
@export var movement_speed: float = 20.0

@export var lower_area_pos: Vector2 = Vector2(20, 20)
@export var upper_area_pos: Vector2 = Vector2(460, 250)

@export_group("Shaders")
@export var overworld_size: Vector2 = Vector2(480, 270)
@export var position_marker: Node2D

# --- Functions --- #
func _process(_delta) -> void:
	velocity = get_input().normalized() * movement_speed
	move_and_slide()
	
	RenderingServer.global_shader_parameter_set('player_position', position_marker.global_position / overworld_size)

func get_input() -> Vector2:
	return Vector2(Input.get_axis('overworld_left', 'overworld_right'), Input.get_axis('overworld_up', 'overworld_down'))

func load_position() -> void:
	global_position = Globals.player_area_pos

func prepare_transition(direction: String) -> void:
	match direction:
		'top':
			Globals.player_area_pos = Vector2(global_position.x, upper_area_pos.y)
		'bottom':
			Globals.player_area_pos = Vector2(global_position.x, lower_area_pos.y)
		'left':
			Globals.player_area_pos = Vector2(upper_area_pos.x, global_position.y)
		'right':
			Globals.player_area_pos = Vector2(lower_area_pos.x, global_position.y)
