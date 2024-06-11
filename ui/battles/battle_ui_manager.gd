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

@export var action_bar_tween_time: float = 0.15
@export var action_bar_offset: float = 10
var action_bar_pos: float

@export_group("Timings")
@export var single_hit: TimedSingleHit

@export var result_label: Label
@export var good_color := Color.WHITE;
@export var perf_color := Color.WHITE;
@export var poor_color := Color.WHITE;
var result_color: Color

# --- Constants --- #
const SINGLE_HIT_NAME = &"single_hit"

# --- Functions --- #
func _ready():
	Globals.ui_manager = self
	
	action_bar_pos = action_bar.position.y
	action_bar.modulate.a = 0
	
	set_attack_menu(false)
	set_victory_panel(false)
	set_loss_panel(false)

#region HP
func setup_entity_hp(hp_bar, entity: Entity) -> void:
	hp_bar.visible = not not entity
	if not entity:
		return
	
	entity.lost_health.connect(hp_bar.update_health)
	hp_bar.update_health(0, entity)

func setup_player_hp(player: Entity, index: int) -> void:
	setup_entity_hp(player_hp_bars[index], player)

func setup_enemy_hp(enemy: Entity, index: int):
	setup_entity_hp(enemy_hp_bars[index], enemy)

func setup_player_special(player: Entity, index: int):
	player.special_increased.connect(player_hp_bars[index].update_special)
	player_hp_bars[index].update_special(player)
#endregion

func _on_state_changed(state: String) -> void:
	is_player_turn = state == 'player'
	set_action_bar(is_player_turn)

func _on_action_changed(state: String) -> void:
	set_attack_menu(state == 'attack')

#region Actions
func try_set_action_bar(value: bool) -> void:
	set_action_bar(is_player_turn and value)

func set_action_bar(value: bool) -> void:
	var tween = create_tween().set_parallel()
	if value:
		action_bar.mouse_filter = Control.MOUSE_FILTER_STOP
		
		action_bar.position.y = action_bar_pos + action_bar_offset
		
		tween.tween_property(action_bar, 'modulate:a', 1.0, action_bar_tween_time)
		tween.tween_property(action_bar, 'position:y', action_bar_pos, action_bar_tween_time)
	else:
		action_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		action_bar.position.y = action_bar_pos
		
		tween.tween_property(action_bar, 'modulate:a', 0.0, action_bar_tween_time)
		tween.tween_property(action_bar, 'position:y', action_bar_pos + action_bar_offset, action_bar_tween_time)

func set_attack_menu(value: bool) -> void:
	attack_menu.visible = value
#endregion

func update_wave_counter(curr: int, wave_count: int) -> void:
	wave_label.text = "Wave: " + str(curr) + "/" + str(wave_count)

func update_condition(condition: String) -> void:
	condition_label.text = "Condition: " + condition

#region Panels
func set_victory_panel(val: bool) -> void:
	victory_panel.visible = val

func set_loss_panel(val: bool) -> void:
	loss_panel.visible = val
#endregion

#region Timing
func show_timing(version: StringName, target: Variant) -> void:
	single_hit.visible = version == SINGLE_HIT_NAME
	if version == SINGLE_HIT_NAME:
		single_hit.setup_timing(target)

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
	
	var tween = create_tween()
	
	tween.tween_interval(0.5)
	tween.tween_method(set_result_text_alpha, 1.0, 0.0, 0.5)
	tween.finished.connect(result_label.hide)

func set_result_text_alpha(alpha: float):
	result_color.a = alpha
	result_label.add_theme_color_override('font_color', result_color)
#endregion
