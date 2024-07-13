class_name BattleUiManager
extends CanvasLayer

# --- Variables --- #
@export_group("Health Bars")
@export var player_hp_bars: Array[HpBar]
@export var enemy_hp_bars: Array[HpBar]

@export_group("Labels")
@export var wave_label: Label
@export var condition_label: Label

@export_group("Panels")
@export var victory_panel: Control
@export var loss_panel: Control

@export_group("Actions")
var is_player_turn := false
@export var action_bar: Control
@export var attack_menu: Control
@export var defense_menu: Control
@export var tactic_menu: Control

@export var cancel_button: Control

@export var action_bar_tween_time: float = 0.15
@export var action_bar_offset: float = 10
var action_bar_pos: float = 238
var menu_pos: float = -115

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
const SINGLE_HIT_NAME = &"single_hit"
const MASH_NAME = &'mash'

# --- Functions --- #
func _ready():
	Globals.ui_manager = self
	
	action_bar_pos = action_bar.position.y
	action_bar.modulate.a = 0

#region HP
func setup_player_hp(player: Entity, index: int) -> void:
	player_hp_bars[index].set_entity(player)

func setup_enemy_hp(enemy: Entity, index: int):
	enemy_hp_bars[index].set_entity(enemy)
#endregion

func _on_state_changed(state: String) -> void:
	is_player_turn = state == 'player'
	set_action_bar(is_player_turn)

func _on_action_changed(state: String) -> void:
	set_attack_menu(state == 'attack')
	set_defense_menu(state == 'defend')
	set_tactic_menu(state == 'tactic')

func _on_targeting_changed() -> void:
	try_set_action_bar(not Globals.action_fsm.targeting)
	set_cancel_button(is_player_turn and Globals.action_fsm.targeting)

#region Actions
func try_set_action_bar(value: bool) -> void:
	set_action_bar(is_player_turn and value)

func tween_action(control: Control, value: bool, pos: float) -> void:
	if value and control.modulate.a > 0.0:
		return
	
	var tween = create_tween().set_parallel()
	
	if value:
		control.visible = true
		
		control.mouse_filter = Control.MOUSE_FILTER_STOP
		
		control.position.y = pos + action_bar_offset
		
		tween.tween_property(control, 'modulate:a', 1.0, action_bar_tween_time)
		tween.tween_property(control, 'position:y', pos, action_bar_tween_time)
		tween.chain().tween_callback(control.show)
	else:
		control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		control.position.y = pos
		
		tween.tween_property(control, 'modulate:a', 0.0, action_bar_tween_time)
		tween.tween_property(control, 'position:y', pos + action_bar_offset, action_bar_tween_time)
		tween.chain().tween_callback(control.hide)

func set_action_bar(value: bool) -> void:
	tween_action(action_bar, value, action_bar_pos)

func set_attack_menu(value: bool) -> void:
	tween_action(attack_menu, value, menu_pos)

func set_defense_menu(value: bool) -> void:
	tween_action(defense_menu, value, menu_pos)

func set_tactic_menu(value: bool) -> void:
	tween_action(tactic_menu, value, menu_pos)

func set_cancel_button(value: bool) -> void:
	tween_action(cancel_button, value, action_bar_pos)

func load_attacks() -> void:
	attack_menu.load_items(Globals.curr_entity.actions.attack_pool)

func load_defenses() -> void:
	defense_menu.load_items(Globals.curr_entity.actions.defense_pool)
#endregion

func update_wave_counter(curr: int, wave_count: int) -> void:
	wave_label.text = "Wave: " + str(curr) + "/" + str(wave_count)

func update_condition(condition: String) -> void:
	condition_label.text = "Condition: " + condition

#region Panels
#func set_victory_panel(val: bool) -> void:
	#victory_panel.show_panel()

func set_loss_panel(val: bool) -> void:
	loss_panel.visible = val
#endregion

#region Timing
func show_timing(version: StringName, target: Variant, param: Variant = null) -> void:
	if Globals.action_fsm.targeting:
		return
	
	single_hit.visible = version == SINGLE_HIT_NAME
	mash_timing.visible = version == MASH_NAME
	
	if version == SINGLE_HIT_NAME:
		single_hit.setup_timing(target)
	elif version == MASH_NAME:
		mash_timing.setup_timing(target, param)

func enable_timing() -> void:
	await get_tree().process_frame
	
	if single_hit.visible:
		single_hit.set_active()
	elif mash_timing.visible:
		mash_timing.set_active()

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
