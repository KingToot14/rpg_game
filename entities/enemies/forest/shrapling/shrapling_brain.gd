class_name ShraplingBrain
extends EntityBrain

# --- Variables --- #
var bark_stages := 4

@export var thorns_attack: Attack

# --- Functions --- #
func _ready() -> void:
	super()
	
	bark_stages = 4
	
	parent.took_damage.connect(_on_take_damage)

func _on_turn_started(_params := {}) -> void:
	action = parent.actions.get_random() as Attack
	
	if action.animation_name == &'acorn_spit':
		# repeat a few times
		Globals.turn_fsm.add_busy()
		
		for i in range(randi_range(2, 3)):
			await perform_action()
		
		parent.turn.end_turn()
		Globals.turn_fsm.remove_busy()
	else:
		perform_action()

func _on_take_damage(params := {}) -> void:
	if bark_stages <= 0:
		return
	
	if params.get(&'use_magic', true):
		return
	
	var sprite = parent.get_node_or_null('sprite/bark' + str(bark_stages))
	if sprite:
		sprite.hide()
	
	bark_stages -= 1
	
	# thorns damage
	var dmg = thorns_attack.calculate_damage(params[&'target'], params[&'entity'])
	dmg[&'source'] = &'counter'
	
	params[&'entity'].hp.take_damage(dmg)
	%'bark_particles'.emitting = true
