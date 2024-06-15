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

@export var status_effects = {}
var removal_queue: Array[StringName] = []

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
var targeting_tween: Tween
var targeting_origin: float

# --- Functions --- #
func _ready() -> void:
	for attack in attack_pool:
		valid_attacks.append(attack.animation_name)
	
	lost_health.connect(show_damage_marker)
	lost_health.connect(play_damage_anim)
	
	targeting_origin = targeting_marker.position.y
	targeting_marker.visible = true
	targeting_marker.modulate.a = 0
	
	if not is_player:
		brain = $"brain" as EntityBrain

func setup(index: int):
	if is_player:
		var player_chunk = DataManager.players[index]
		hp = round(player_chunk.curr_hp)
		special_charge = player_chunk.curr_special
		stats = player_chunk.stats
	else:
		hp = get_max_hp()
	spawn_index = index
	
	animator.play(&'enter_battle')
	animator.queue(&'idle')

#region Targeting
func set_targetable(val: bool) -> void:
	targetable = val
	
	var tween = create_tween().set_parallel()
	
	if targetable:
		targeting_marker.modulate.a = 0
		targeting_marker.position.y = targeting_origin + 4
		tween.tween_property(targeting_marker, 'modulate:a', 1.0, 0.25)
		tween.tween_property(targeting_marker, 'position:y', targeting_origin, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tween.tween_property(targeting_marker, 'modulate:a', 0.0, 0.25)
		tween.tween_property(targeting_marker, 'position:y', targeting_origin + 4, 0.25)

func _on_mouse_entered():
	is_mouse_over = true
	targeting_marker.frame = 1
	
	targeting_tween = create_tween().set_loops(0)
	targeting_tween.tween_property(targeting_marker, 'position:y', targeting_origin - 4, 0.75)
	targeting_tween.tween_property(targeting_marker, 'position:y', targeting_origin, 0.0)

func _on_mouse_exited():
	is_mouse_over = false
	targeting_marker.frame = 0
	
	if targeting_tween:
		targeting_tween.stop()
		targeting_marker.position.y = targeting_origin
#endregion

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if not (event.pressed and is_mouse_over):
		return
	
	select()

func select() -> void:
	selected.emit(self)

#region HP
func take_damage(dmg: int, from_entity: bool = true):
	if from_entity:
		for effect in status_effects.values():
			dmg = effect.take_damage(dmg)
		
		remove_effects()
	
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
		animator.stop()
		animator.play(&'take_damage')
		animator.queue(&'idle')
	else:
		remove_from_battle()
		animator.play(&'death')

func get_hp_percent() -> float:
	return hp / get_max_hp()

func remove_from_battle() -> void:
	Globals.encounter_manager.remove_from_battle(self, spawn_index)
#endregion

#region Actions
func take_turn() -> void:
	for effect in status_effects.values():
		effect.turn_started()
	
	remove_effects()
	
	if not is_player:
		brain.perform_turn()

func replenish_actions() -> void:
	action_count = 1

func decrement_action() -> void:
	for effect in status_effects.values():
		effect.turn_ended()
	
	remove_effects()
	
	action_count -= 1

func can_act() -> bool:
	return alive and action_count > 0
#endregion

#region Stats
func get_max_hp() -> float:
	var max_hp = stats.max_hp
	
	for effect in status_effects.values():
		max_hp = effect.get_max_hp(max_hp)
	
	return max_hp

func get_attack(use_magic: bool) -> float:
	var attack = stats.m_attack if use_magic else stats.p_attack
	
	for effect in status_effects.values():
		if use_magic:
			attack = effect.get_m_attack(attack)
		else:
			attack = effect.get_p_attack(attack)
	
	return attack

func get_defense(use_magic: bool) -> float:
	var defense = stats.m_defense if use_magic else stats.p_defense
	
	for effect in status_effects.values():
		if use_magic:
			defense = effect.get_m_defense(defense)
		else:
			defense = effect.get_p_defense(defense)
	
	return defense

func get_accuracy() -> float:
	var accuracy = stats.accuracy
	
	for effect in status_effects.values():
		accuracy = effect.get_accuracy(accuracy)
	
	return accuracy

func get_evasion() -> float:
	var evasion = stats.max_hp
	
	for effect in status_effects.values():
		evasion = effect.get_evasion(hp)
	
	return evasion

func get_resistance(resistance: Attack.Element) -> float:
	var mod := 0.0
	
	if resistance in stats.resistances:
		mod = stats.resistances[resistance]
	
	for effect in status_effects.values():
		mod = effect.get_resistance(resistance, mod)
	
	return mod
	
#endregion

# - Effects - #
func show_damage_marker(dmg: int, _entity: Entity) -> void:
	var damage_marker = Globals.object_pool.get_item('damage_marker') as DamageMarker
	
	damage_marker.visible = true
	damage_marker.global_position = marker_pos.global_position
	damage_marker.set_text(dmg, 0)
	damage_marker.start_fade()

func add_effect(key: StringName, stacks: int = 1, stage: int = 1) -> void:
	if key in status_effects:
		status_effects[key].add_stacks(stacks, stage)
	else:
		status_effects[key] = Globals.registered_effects[key].new(self, stacks, stage)

func queue_removal(effect: StringName) -> void:
	removal_queue.append(effect)

func remove_effects() -> void:
	for effect in removal_queue:
		if effect in status_effects:
			status_effects.erase(effect)

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
