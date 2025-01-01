class_name OverworldController
extends CharacterBody2D

# --- Variables --- #
var direction: Vector2
var dir_string := "down"

var prev_position: Vector2
var pos_delta: Vector2

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

@onready var animator := %'animator' as AnimationPlayer

var curr_state: PlayerControlState

# --- Functions --- #
func _ready() -> void:
	set_state('moving')
	
	animator.play(&'walk_down')
	
	await get_tree().process_frame
	# signals
	Globals.overworld_manager.area_loaded.connect(end_transition)

func _physics_process(delta: float) -> void:
	get_direction()
	
	curr_state.handle_process(delta)
	
	pos_delta = prev_position - position
	prev_position = position
	update_texture()
	
	RenderingServer.global_shader_parameter_set('player_position', position_marker.global_position / overworld_size)

func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	curr_state = get_node(state + "_state") as PlayerControlState

func get_direction() -> void:
	direction = Vector2(Input.get_axis('overworld_left', 'overworld_right'), Input.get_axis('overworld_up', 'overworld_down')).normalized()
	
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x < 0:
				sprite.flip_h = true
				dir_string = "right"
			else:
				sprite.flip_h = false
				dir_string = "right"
		else:
			if direction.y < 0:
				dir_string = "up"
			else:
				dir_string = "down"

#region Sprites
func update_texture() -> void:
	if pos_delta == Vector2.ZERO:
		animator.play("idle_%s" % dir_string)
	else:
		animator.play("walk_%s" % dir_string)

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
