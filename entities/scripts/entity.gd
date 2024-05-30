class_name Entity
extends Node2D

# --- Signals --- #
signal lost_health(dmg: int, remaining: int)
signal died()

# --- Variables --- #
var alive: bool = true

@export_group("Stats")
@export var max_hp: float
var hp: float
@export var p_attack: float
@export var p_defense: float
@export var m_attack: float
@export var m_defense: float
@export var accuracy: float
@export var evasion: float

@export_group("Attacks")
@export var default_attack: Attack
@export var attack_pool: Array[Attack]

# --- Functions --- #
func _ready():
	hp = max_hp

func take_damage(dmg: int):
	hp = max(hp - dmg, 0)
	lost_health.emit(dmg, hp)
	
	if hp <= 0:
		alive = false
		died.emit()

func kill():
	queue_free()
