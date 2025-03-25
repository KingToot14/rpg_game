class_name BattleUiManager
extends CanvasLayer

# --- Enums --- #
enum ActionState {
	Hidden,
	ActionBar,
	CancelButton
}

# --- Variables --- #
@export_group("Panels")
@export var victory_panel: Control
@export var loss_panel: Control

@export_group("Actions")
var is_player_turn := false
@export var action_bar: Control

@export var cancel_button: Control

@export var action_bar_tween_time: float = 0.15
var action_bar_tween: Tween
var action_bar_pos: float = 238

@export_group("Timings")
@export var single_hit: TimedSingleHit
@export var mash_timing: MashTiming

@export var result_label: Label
@export var good_color := Color.WHITE;
@export var perf_color := Color.WHITE;
@export var poor_color := Color.WHITE;
var result_color: Color
var result_tween: Tween

# --- References --- #
@onready var entity_info_panel := %'entity_info' as EntityInfoUi

# --- Constants --- #
const SINGLE_HIT_NAME = &'single_hit'
const MASH_NAME = &'mash'

# --- Functions --- #
func _ready():
	Globals.ui_manager = self
	
	action_bar_pos = action_bar.position.y
	action_bar.modulate.a = 0

#region HP
func setup_player_hp(player: Entity, index: int) -> void:
	var hp_bars = %'player_hp'
	
	hp_bars.get_child(index + 1).set_entity(player)

func setup_enemy_hp(enemy: Entity, index: int) -> void:
	var hp_bars = %'enemy_hp'
	
	hp_bars.get_child(index + 1).set_entity(enemy)
#endregion

#region Actions
func set_action_state(state: BattleUiManager.ActionState) -> void:
	if state == ActionState.ActionBar:
		show_action_bar()
	else:
		hide_action_bar()
	
	if state == ActionState.CancelButton:
		cancel_button.show_button()
	else:
		cancel_button.hide_button()

func show_action_bar() -> void:
	if action_bar_tween:
		action_bar_tween.kill()
	action_bar_tween = create_tween().set_parallel()
	
	action_bar.mouse_filter = Control.MOUSE_FILTER_STOP
	
	action_bar.show()
	action_bar_tween.tween_property(action_bar, 'modulate:a', 1.0, action_bar_tween_time)
	action_bar_tween.tween_property(action_bar, 'position:y', 0, action_bar_tween_time).from(8)

func hide_action_bar() -> void:
	if action_bar_tween:
		action_bar_tween.kill()
	action_bar_tween = create_tween().set_parallel()
	
	action_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	action_bar_tween.tween_property(action_bar, 'modulate:a', 0.0, action_bar_tween_time)
	action_bar_tween.tween_property(action_bar, 'position:y', 8, action_bar_tween_time)
	action_bar_tween.finished.connect(action_bar.hide)
	
	# hide menus
	%'attack_menu'.hide_menu()
	%'items_menu'.hide_menu()
	%'tactics_menu'.hide_menu()

func clear_action() -> void:
	for entity: Entity in get_tree().get_nodes_in_group(&'player'):
		entity.brain._on_action_selected(null)

func load_player_action(entity: Entity) -> void:
	%'attack_menu'.load_items(entity.actions.attack_pool)

#endregion

func update_wave_counter(curr: int, wave_count: int) -> void:
	%'wave_label'.text = "%d/%d" % [curr, wave_count]

func update_condition(condition: String) -> void:
	%'condition_label'.text = condition

#region Panels
func set_loss_panel(val: bool) -> void:
	loss_panel.visible = val
#endregion

#region Timing
func show_timing(version: StringName, timings: Variant, param: Variant = null) -> void:
	single_hit.visible = version == SINGLE_HIT_NAME
	mash_timing.visible = version == MASH_NAME
	
	if version == SINGLE_HIT_NAME:
		single_hit.setup_timing(timings)
		await get_tree().process_frame
		single_hit.activate()
	elif version == MASH_NAME:
		mash_timing.setup_timing(timings, param)
		await get_tree().process_frame
		mash_timing.activate()

func enable_timing() -> void:
	await get_tree().process_frame
	
	if single_hit.visible:
		single_hit.activate()
	elif mash_timing.visible:
		mash_timing.activate()

func show_timing_result(key: StringName) -> void:
	result_label.visible = true
	
	match key:
		&'perfect':
			result_label.text = "Perfect!"
			result_color = perf_color
		&'good':
			result_label.text = "Good"
			result_color = good_color
		&'poor':
			result_label.text = "Poor"
			result_color = poor_color
	
	set_result_text_alpha(1.0)
	
	if result_tween:
		result_tween.kill()
	
	result_tween = create_tween()
	
	result_tween.tween_interval(0.5)
	result_tween.tween_method(set_result_text_alpha, 1.0, 0.0, 0.5)
	result_tween.finished.connect(result_label.hide)

func set_result_text_alpha(alpha: float):
	result_color.a = alpha
	result_label.add_theme_color_override('font_color', result_color)
#endregion
