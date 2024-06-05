class_name OverworldController
extends CharacterBody2D

# --- Variables --- #
@export var movement_speed: float = 20.0
var direction: Vector2

@export var lower_area_pos: Vector2 = Vector2(20, 20)
@export var upper_area_pos: Vector2 = Vector2(460, 250)

@export_group("Textures")
@export var front_threshold: float = 0.10
@export var texture_front: Texture2D
@export var texture_back: Texture2D
@export var texture_side_front: Texture2D
@export var texture_side_back: Texture2D
var texture_direction: int = 0

@export_group("Shaders")
@export var overworld_size: Vector2 = Vector2(480, 270)
@export var position_marker: Node2D

# --- References --- #
@onready var sprite: Sprite2D = $"sprite"
@onready var reflection_sprite: ReflectionTexture = $"reflection"

# --- Functions --- #
func _physics_process(_delta) -> void:
	get_direction()
	velocity = direction * movement_speed
	move_and_slide()
	update_texture()
	
	RenderingServer.global_shader_parameter_set('player_position', position_marker.global_position / overworld_size)

func get_direction() -> void:
	direction = Vector2(Input.get_axis('overworld_left', 'overworld_right'), Input.get_axis('overworld_up', 'overworld_down')).normalized()

func update_texture() -> void:
	if direction == Vector2.ZERO:
		return
	
	var tex_dir = 0
	sprite.flip_h = direction.x > 0.0
	reflection_sprite.flip_h = sprite.flip_h
	
	if abs(direction.x) < front_threshold:
		tex_dir = 0 if direction.y >= 0.0 else 1
		sprite.texture = texture_front if direction.y >= 0.0 else texture_back
	else:
		tex_dir = 2 if direction.y >= 0.0 else 3
		sprite.texture = texture_side_front if direction.y >= 0.0 else texture_side_back
	
	if tex_dir != texture_direction:
		reflection_sprite.generate_texture()
		texture_direction = tex_dir

func load_position() -> void:
	global_position = DataManager.local_area.player_position

func prepare_transition(dir: String) -> void:
	match dir:
		'top':
			DataManager.local_area.player_position = Vector2(global_position.x, upper_area_pos.y)
		'bottom':
			DataManager.local_area.player_position = Vector2(global_position.x, lower_area_pos.y)
		'left':
			DataManager.local_area.player_position = Vector2(upper_area_pos.x, global_position.y)
		'right':
			DataManager.local_area.player_position = Vector2(lower_area_pos.x, global_position.y)

func prepare_battle() -> void:
	DataManager.local_area.player_position = global_position
