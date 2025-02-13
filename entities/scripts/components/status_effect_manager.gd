class_name StatusEffectManager
extends Node

# --- Signals --- #
signal effect_added()

# --- Variables --- #
var status_effects: Array[StatusEffect] = []
var removal_queue: Array[StringName] = []

# --- References --- #
var parent: Entity
var timer: Timer

# --- Functions --- #
func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	
	add_child(timer)

func setup(entity: Entity) -> void:
	parent = entity
	
	# setup signals
	parent.turn_started.connect(_on_turn_started)
	parent.turn_ended.connect(_on_turn_ended)

func _on_turn_started(_params = {}) -> void:
	for effect in status_effects:
		var wait_time = effect.turn_started()
		
		if wait_time > 0.0:
			timer.start(wait_time)
			await timer.time_out
	
	remove_effects()

func _on_turn_ended() -> void:
	for effect in status_effects:
		var wait_time = effect.turn_ended()
		
		if wait_time > 0.0:
			timer.start(wait_time)
			await timer.timeout
	
	remove_effects()

func add_effect(key: StringName, stacks := 1, stage := 1) -> void:
	var effect = get_effect(key)
	
	if effect:
		effect.add_stacks(stacks, stage)
	else:
		effect = StatusEffectHelper.get_effect(key).effect_class.new(parent, stacks, stage)
		effect.key = key
		status_effects.append(effect)
	
	effect_added.emit()

func remove_effect(key: StringName, stacks = -1) -> void:
	var effect = get_effect(key)
	
	if effect:
		if stacks < 0:
			status_effects.erase(effect)
		else:
			for i in range(stacks):
				effect.decrement_stacks()

func get_effect(key: StringName) -> StatusEffect:
	for effect in status_effects:
		if effect.key == key:
			return effect
	
	return null

func has_effect(key: StringName, min_stacks := 0, min_stage := 0) -> bool:
	var effect = get_effect(key)
	
	if not effect:
		return false
	
	return not (effect.stacks < min_stacks or effect.stage < min_stage)

func queue_removal(effect: StringName) -> void:
	removal_queue.append(effect)

func remove_effects() -> void:
	for effect in status_effects:
		if effect.key in removal_queue:
			status_effects.erase(effect)
	
	removal_queue.clear()
