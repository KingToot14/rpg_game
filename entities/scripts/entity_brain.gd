class_name EntityBrain
extends Node

# --- Variables --- #
@export var action_delay: float = 0.5

var action: ActionResource
var selected_target: Entity

var attack_obj: PackedScene

# --- References --- #
var parent: Entity

const PERF_MOD := 1.15
const GOOD_MOD := 1.00
const POOR_MOD := 0.90

# --- Functions --- #
func _ready() -> void:
	parent = $'../..'
	
	# setup signals
	parent.turn_started.connect(_on_turn_started)

func _on_turn_started(_params := {}) -> void:
	return

func _on_action_selected(new_action: ActionResource) -> void:
	if not parent.turn.taking_turn:
		return
	
	action = new_action

func _on_entity_selected(entity: Entity) -> void:
	if not parent.turn.taking_turn:
		return
	
	selected_target = entity

func setup_and_perform(new_action: ActionResource, target: Entity) -> void:
	action = new_action
	selected_target = target
	
	perform_action(false)

func perform_action(cooldown := true) -> void:
	# cooldown action
	if cooldown:
		parent.turn.actions_remaining -= 1
		action.start_cooldown()
	
	# load objects
	if action is Attack and action.attack_obj != "":
		await load_object(action.attack_obj)
	
	# perform action
	parent.animator.play_action_anim(action.animation_name)
	
	# setnd signals
	var action_string = ""
	
	if action is Attack:
		action_string = "attack"
	elif action is Defense:
		action_string = "defend"
	elif action.name == "Skip":
		action_string = "skip"
	
	parent.performed_action.emit({
		&'action': action_string,
		&'entity': parent,
		&'target': selected_target
	})

func load_object(path: String) -> void:
	var loader = AsyncLoader.new(path, func(scn: PackedScene): attack_obj = scn)
	await loader.done_loading

func activate_object(target) -> void:
	if attack_obj:
		var obj = attack_obj.instantiate() as AttackObject
		get_tree().current_scene.add_child(obj)
		
		# perform attack
		obj.setup({
			&'entity': parent,
			&'target': target
		})
		obj.perform_attack()

func do_damage(target: Entity, damage_mod := 1.0) -> void:
	var attack := action as Attack
	
	var dmg_chunk := attack.calculate_damage(parent, target) as Dictionary
	
	# call deal damage effects
	parent.deal_damage.emit(dmg_chunk)
	
	# apply timing mods
	if parent.is_player() and len(Globals.timing_mods) > 0:
		var timing_mod = Globals.timing_mods.pop_front()
		
		if timing_mod == &'perf':
			dmg_chunk[&'damage'] *= PERF_MOD
		elif timing_mod == &'good':
			dmg_chunk[&'damage'] *= GOOD_MOD
		else:
			dmg_chunk[&'damage'] *= POOR_MOD
	
	dmg_chunk[&'damage'] *= damage_mod
	
	# set target
	target.hp.take_damage(dmg_chunk)
