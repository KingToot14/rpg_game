class_name Entity
extends Node2D

# --- Signals --- #
signal lost_health(dmg: int, entity: Entity)
signal died()

signal special_increased(entity: Entity)
signal special_full()

signal selected(entity: Entity)

# --- Variables --- #
@export var is_player := false
@export var use_special := false
var alive: bool = true
var spawn_index: int

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

@export_group("Effects")
@export var marker_pos: Node2D
@export var death_delay: float = 0.25

var is_mouse_over: bool = false

# --- References --- #
@onready var brain: EntityBrain
@onready var animator := $"animator" as AttackAnimator

# --- Functions --- #
func _ready() -> void:
	lost_health.connect(show_damage_marker)
	
	if not is_player:
		brain = $"brain" as EntityBrain

func setup(index: int):
	hp = max_hp
	spawn_index = index

func _on_mouse_entered():
	is_mouse_over = true

func _on_mouse_exited():
	is_mouse_over = false

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if not (event.pressed and is_mouse_over):
		return
	
	select()

func select() -> void:
	selected.emit(self)

# - HP - #
func take_damage(dmg: int):
	hp = max(hp - dmg, 0)
	lost_health.emit(dmg, self)
	
	if use_special:
		special_charge = min(special_charge + dmg / 20.0, 100)
		special_increased.emit(self)
	
	if hp <= 0:
		alive = false
		died.emit()

func get_hp_percent() -> float:
	return hp / max_hp

func kill() -> void:
	get_parent().remove_from_battle(self, spawn_index)
	await get_tree().create_timer(death_delay).timeout
	queue_free()

# - Actions - #
func take_turn() -> void:
	if not is_player:
		brain.perform_turn()

func replenish_actions() -> void:
	action_count = 1

func decrement_action() -> void:
	action_count -= 1

func can_act() -> bool:
	return alive and action_count > 0

# - Stats - #
func get_attack(use_magic: bool) -> float:
	return m_attack if use_magic else p_attack

func get_defense(use_magic: bool) -> float:
	return m_defense if use_magic else p_defense

# - Effects - #
func show_damage_marker(dmg: int, _entity: Entity) -> void:
	var damage_marker = Globals.object_pool.get_item('damage_marker') as DamageMarker
	
	damage_marker.visible = true
	damage_marker.global_position = marker_pos.global_position
	damage_marker.set_text(dmg, 0)
	damage_marker.start_fade()

# - Attacks - #
func perform_attack(attack_name: StringName) -> void:
	animator.play(attack_name)
	animator.animation_finished.connect(action_ended, CONNECT_ONE_SHOT)

func action_ended(_s: String) -> void:
	Globals.action_fsm.perform_action()

func get_timed_inputs(attack_name: StringName) -> Array[float]:
	var attack_anim = animator.get_animation(attack_name)
	if not attack_anim:
		return []
	
	var track_id = attack_anim.find_track(^'animator', Animation.TYPE_METHOD)
	var key_count = attack_anim.track_get_key_count(track_id)
	
	var locations: Array[float] = []
	for i in range(key_count):
		if attack_anim.track_get_key_value(track_id, i)['method'] == &'timed_input':
			locations.append(attack_anim.track_get_key_time(track_id, i))
	
	return locations
