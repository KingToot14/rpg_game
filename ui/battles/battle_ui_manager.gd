class_name BattleUiManager
extends CanvasLayer

# --- Variables --- #
@export var player_hp_bars: Array[HpBar]
@export var enemy_hp_bars: Array[HpBar]

# --- Functions --- #
func setup_player_hp(player: Entity, index: int):
	player.lost_health.connect(player_hp_bars[index].update_health)
	player.setup_hp()
	player_hp_bars[index].update_health(0, player)

func setup_enemy_hp(enemy: Entity, index: int):
	enemy.lost_health.connect(enemy_hp_bars[index].update_health)
	enemy.setup_hp()
	enemy_hp_bars[index].update_health(0, enemy)

func setup_player_special(player: Entity, index: int):
	player.special_increased.connect(player_hp_bars[index].update_special)
	player_hp_bars[index].update_special(player)
