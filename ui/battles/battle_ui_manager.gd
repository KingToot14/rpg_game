class_name BattleUiManager
extends CanvasLayer

# --- Variables --- #
@export_group("Health Bars")
@export var player_hp_bars: Array[HpBar]
@export var enemy_hp_bars: Array[HpBar]

@export_group("Labels")
@export var wave_label: Label
@export var condition_label: Label

@export_group("Actions")
@export var action_bar: Control
@export var attack_menu: Control

# --- Functions --- #
func _ready():
	set_attack_menu(false)

func setup_player_hp(player: Entity, index: int):
	if not player:
		player_hp_bars[index].visible = false
		return
	else:
		player_hp_bars[index].visible = true
	
	player.lost_health.connect(player_hp_bars[index].update_health)
	player.setup(index)
	player_hp_bars[index].update_health(0, player)

func setup_enemy_hp(enemy: Entity, index: int):
	if not enemy:
		enemy_hp_bars[index].visible = false
		return
	else:
		enemy_hp_bars[index].visible = true
	
	enemy.lost_health.connect(enemy_hp_bars[index].update_health)
	enemy.setup(index)
	enemy_hp_bars[index].update_health(0, enemy)

func setup_player_special(player: Entity, index: int):
	player.special_increased.connect(player_hp_bars[index].update_special)
	player_hp_bars[index].update_special(player)

func _on_state_changed(state: String) -> void:
	set_action_bar(state == 'player')

func _on_action_changed(state: String) -> void:
	set_attack_menu(state == 'attack')

func set_action_bar(value: bool) -> void:
	action_bar.visible = value

func set_attack_menu(value: bool) -> void:
	attack_menu.visible = value

func update_wave_counter(curr: int, wave_count: int) -> void:
	wave_label.text = "Wave: " + str(curr) + "/" + str(wave_count)

func update_condition(condition: String) -> void:
	condition_label.text = "Condition: Normal"
