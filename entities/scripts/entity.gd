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
var performing: bool = false

# - Stats - #
@export var stats: EntityStats
var hp: float
var special_charge: float = 0

var action_count: int = 0

# - Attacks - #
@export_group("Attacks")
@export var default_attack: Attack
@export var attack_pool: Array[Attack]
var valid_attacks: Array[StringName] = []

@export var front_marker: Node2D

@export_group("Effects")
@export var marker_pos: Node2D

var is_mouse_over: bool = false
var targetable: bool = false

# --- References --- #
@onready var brain: EntityBrain
@export var animator: AttackAnimator

@onready var targeting_marker := $"targeting_marker" as Sprite2D

# --- Functions --- #
func _ready() -> void:
	for attack in attack_pool:
		valid_attacks.append(attack.animation_name)
	
	lost_health.connect(show_damage_marker)
	lost_health.connect(play_damage_anim)
	
	if not is_player:
		brain = $"brain" as EntityBrain

func setup(index: int):
	if is_player:
		var player_chunk = DataManager.players[index]
		hp = round(player_chunk.curr_hp)
		special_charge = player_chunk.curr_special
		stats = player_chunk.stats
	else:
		hp = stats.max_hp
	spawn_index = index
	
	animator.play(&'enter_battle')
	animator.queue(&'idle')

func set_targetable(val: bool) -> void:
	targetable = val
	targeting_marker.visible = targetable

func _on_mouse_entered():
	is_mouse_over = true
	targeting_marker.frame = 1

func _on_mouse_exited():
	is_mouse_over = false
	targeting_marker.frame = 0

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
	
	if use_special:
		special_charge = min(special_charge + dmg / 20.0, 100)
		special_increased.emit(self)
	
	if hp <= 0:
		alive = false
	
	lost_health.emit(dmg, self)

func do_death() -> void:
	died.emit()
	queue_free()

func play_damage_anim(_dmg: int, _entity: Entity) -> void:
	if alive:
		animator.play(&'take_damage')
		animator.queue(&'idle')
	else:
		remove_from_battle()
		animator.play(&'death')

func get_hp_percent() -> float:
	return hp / stats.max_hp

func remove_from_battle() -> void:
	Globals.encounter_manager.remove_from_battle(self, spawn_index)

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
	return stats.m_attack if use_magic else stats.p_attack

func get_defense(use_magic: bool) -> float:
	return stats.m_defense if use_magic else stats.p_defense

# - Effects - #
func show_damage_marker(dmg: int, _entity: Entity) -> void:
	var damage_marker = Globals.object_pool.get_item('damage_marker') as DamageMarker
	
	damage_marker.visible = true
	damage_marker.global_position = marker_pos.global_position
	damage_marker.set_text(dmg, 0)
	damage_marker.start_fade()

# - Attacks - #
func perform_attack(attack_name: StringName) -> void:
	if performing:
		print("Already performing")
		return
	
	performing = true
	
	animator.play(attack_name)
	animator.animation_finished.connect(action_ended, CONNECT_ONE_SHOT)

func action_ended(_s: String) -> void:
	performing = false
	
	animator.play(&'idle')
	
	Globals.action_fsm.perform_action()
	Globals.ui_manager.show_timing('none', null)

func contains_attack(attack_name: StringName) -> bool:
	return attack_name in valid_attacks

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

# - Positioning - #
func get_front_pos() -> Vector2:
	return front_marker.global_position

# - Data Saving - #
func store_data() -> void:
	DataManager.players[spawn_index].store_hp(hp)
