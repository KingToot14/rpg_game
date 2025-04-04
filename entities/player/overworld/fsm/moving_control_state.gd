class_name MovingControlState
extends PlayerControlState

# --- Variables --- #
var prev_pos: Vector2
@export var movement_speed: float = 20.0
@export var sprint_speed := 100.0

@export var footstep_sfx: Array[FootstepSfx] = []

# --- References --- #
@onready var audio_player := %'audio_player' as SfxPlayer
@onready var footstep_timer := %'footstep_timer' as Timer

# --- Functions --- #
func handle_process(_delta: float) -> void:
	var sprinting = Input.is_action_pressed(&'sprint')
	
	if sprinting:
		player.velocity = player.direction * sprint_speed
	else:
		player.velocity = player.direction * movement_speed
	var collided = player.move_and_slide()
	
	# get position delta
	var _pos_delta = get_parent().prev_position - get_parent().position
	
	# play/pause footsteps
	if not collided and footstep_timer.paused and player.direction != Vector2.ZERO:
		footstep_timer.start()
		play_footstep()
	
	footstep_timer.paused = player.direction == Vector2.ZERO or collided

func play_footstep() -> void:
	if player.in_transition or not Globals.overworld_manager.curr_area:
		return
	
	# make sure position is in bounds
	if not player.get_viewport_rect().has_point(player.position):
		return
	
	var image = Globals.overworld_manager.curr_area.terrain_texture.get_image() as Image
	var color = image.get_pixel(int(player.position.x), int(player.position.y + 4))
	
	for footstep in footstep_sfx:
		if footstep.color_key == color:
			audio_player.play_sfx(footstep.footstep_sound, footstep.volume_modifier)
			return
