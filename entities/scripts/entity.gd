class_name Entity
extends Node2D

# --- Signals --- #
signal lost_health(dmg: int, entity: Entity)
signal died()

signal special_increased(entity: Entity)
signal special_full()

# --- Variables --- #
@export var is_player := false
@export var use_special := false
var alive: bool = true

@export_group("Stats")
@export var max_hp: float
@export var p_attack: float
@export var p_defense: float
@export var m_attack: float
@export var m_defense: float
@export var accuracy: float
@export var evasion: float

var hp: float
var action_count: int = 0
var special_charge: float = 0

@export_group("Attacks")
@export var default_attack: Attack
@export var attack_pool: Array[Attack]

# --- Functions --- #
func setup_hp():
	hp = max_hp

# - HP - #
func take_damage(dmg: int):
	hp = max(hp - dmg, 0)
	lost_health.emit(dmg, self)
	
	if use_special:
		special_charge = min(special_charge + dmg, 100)
		special_increased.emit(self)
	
	if hp <= 0:
		alive = false
		died.emit()

func get_hp_percent() -> float:
	return hp / max_hp

func kill() -> void:
	get_parent().remove_from_battle(self)
	queue_free()

# - Actions - #
func replenish_actions() -> void:
	action_count = 1

func decrement_action() -> void:
	action_count -= 1

func can_act() -> bool:
	return alive and action_count > 0
