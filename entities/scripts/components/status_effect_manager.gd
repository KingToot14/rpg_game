class_name StatusEffectManager
extends Node

# --- Signals --- #
signal effect_changed()

# --- Variables --- #
var status_effects: Array[StatusEffect] = []
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

func _on_turn_started(_params = {}) -> void:
	for effect in status_effects:
		var wait_time = effect.turn_started()
		
		if wait_time > 0.0:
			timer.start(wait_time)
			await timer.time_out

func _on_turn_ended() -> void:
	for effect in status_effects:
		var wait_time = effect.turn_ended()
		
		if wait_time > 0.0:
			timer.start(wait_time)
			await timer.timeout

func add_effect(key: StringName, stacks := 1, stage := 1) -> void:
	var effect = Globals.load_status_effect(key).new(parent)
	
	var params = {
		&'key': key,
		&'stacks': stacks,
		&'stage': stage,
		&'status_type': effect.status_type,
		&'stacks_odds': 0.0
	}
	
	parent.received_status.emit(params)
	
	if params.get(&'ignore', false):
		return
	
	effect = get_effect(params[&'key'])
	
	# attempt to modify stacks
	if randf() < abs(params[&'stacks_odds']):
		var mod = randi_range(1, 2)
		params[&'stacks'] = max(params[&'stacks'] + mod * sign(params[&'stacks_odds']), 0)
	
	if effect:
		# add to current effect if it exists
		effect.add_stacks(params[&'stacks'], params[&'stage'])
	else:
		# create new effect instance
		effect = Globals.load_status_effect(params[&'key']).new(parent, params[&'stacks'], params[&'stage'])
		status_effects.append(effect)
	
	effect_changed.emit()

func remove_effect(key: StringName, stacks = -1) -> void:
	var effect = get_effect(key)
	
	if effect:
		if stacks < 0:
			status_effects.erase(effect)
		else:
			for i in range(stacks):
				effect.decrement_stacks()
	
	effect_changed.emit()

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
