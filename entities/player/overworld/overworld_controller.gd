class_name OverworldController
extends CharacterBody2D

# --- Variables --- #
var direction: Vector2
var in_transition := false

@export var lower_area_pos: Vector2 = Vector2(20, 20)
@export var upper_area_pos: Vector2 = Vector2(460, 250)

@export_group("Textures")
@export var front_threshold: float = 0.10

@export_group("Shaders")
@export var overworld_size: Vector2 = Vector2(480, 270)
@export var position_marker: Node2D

# --- References --- #
@export var sprite: Sprite2D
@onready var reflection_sprite := %"reflection" as Sprite2D
@onready var audio_player := %'audio_player' as SfxPlayer
@onready var footstep_timer := %'footstep_timer' as Timer

var curr_state: PlayerControlState

# --- Functions --- #
func _ready() -> void:
	set_state('moving')
	
	# load appearance
	var data = DataManager.players[0]
	
	if data:
		AsyncLoader.new(data.get_appearance_path(), set_appearance)
	
	await get_tree().process_frame
	# signals
	Globals.overworld_manager.area_loaded.connect(end_transition)

func _physics_process(delta: float) -> void:
	get_direction()
	
	curr_state.handle_process(delta)
	
	RenderingServer.global_shader_parameter_set('player_position', position_marker.global_position / overworld_size)

func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	curr_state = get_node(state + "_state") as PlayerControlState

func get_direction() -> void:
	direction = Vector2(Input.get_axis('overworld_left', 'overworld_right'), Input.get_axis('overworld_up', 'overworld_down')).normalized()

#region Sprites
func update_texture() -> void:
	if direction == Vector2.ZERO:
		return
	
	sprite.flip_h = direction.x > 0.0
	reflection_sprite.flip_h = sprite.flip_h
	
	if abs(direction.x) < front_threshold:
		sprite.frame = 0 if direction.y >= 0.0 else 2
	else:
		sprite.frame = 1 if direction.y >= 0.0 else 3
	
	reflection_sprite.frame = sprite.frame

#endregion

#region Transitions
func load_position() -> void:
	global_position = DataManager.local_area.player_position

func prepare_transition(dir: String) -> void:
	in_transition = true
	
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

func end_transition() -> void:
	in_transition = false

#endregion

#region Appearance
func set_appearance(appearance: PlayerAppearance) -> void:
	sprite.material.set_shader_parameter('outline_color', appearance.outline_color)
	sprite.material.set_shader_parameter('normal_color', appearance.normal_color)
	sprite.material.set_shader_parameter('shadow_color', appearance.shadow_color)

#endregion
