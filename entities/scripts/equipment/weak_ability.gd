class_name WeakAbility
extends EquipmentAbility

# --- Variables --- #
@export var resists: String
@export var element_mod := 0.10
@export var stacks_base := 0.25
@export var stacks_increase := 0.25

var element_weaknesses: Attack.Element
var status_weaknesses: Globals.StatusType

# --- Functions --- #
@warning_ignore("int_as_enum_without_cast")
func setup(new_entity: Entity, new_level: int) -> void:
	super(new_entity, new_level)
	
	# connect signals
	entity.took_damage.connect(_on_take_damage)
	entity.received_status.connect(_on_receive_status)
	
	# parse resist
	for resist in resists.split(","):
		match resist:
			'none':
				element_weaknesses |= Attack.Element.NONE as Attack.Element
			'fire':
				element_weaknesses |= Attack.Element.FIRE as Attack.Element
			'electric':
				element_weaknesses |= Attack.Element.ELECTRIC as Attack.Element
			'nature':
				element_weaknesses |= Attack.Element.NATURE as Attack.Element
			'water':
				element_weaknesses |= Attack.Element.WATER as Attack.Element
			'ice':
				element_weaknesses |= Attack.Element.ICE as Attack.Element
			'flying':
				element_weaknesses |= Attack.Element.FLYING as Attack.Element
			'earth':
				element_weaknesses |= Attack.Element.EARTH as Attack.Element
			'light':
				element_weaknesses |= Attack.Element.LIGHT as Attack.Element
			'dark':
				element_weaknesses |= Attack.Element.DARK as Attack.Element
			'harass':
				status_weaknesses |= Globals.StatusType.HARASS as Globals.StatusType
			'hinder':
				status_weaknesses |= Globals.StatusType.HINDER as Globals.StatusType
			'life':
				status_weaknesses |= Globals.StatusType.LIFE as Globals.StatusType
			'death':
				status_weaknesses |= Globals.StatusType.DEATH as Globals.StatusType
			'body':
				status_weaknesses |= Globals.StatusType.BODY as Globals.StatusType
			'environment':
				status_weaknesses |= Globals.StatusType.ENVIRONMENT as Globals.StatusType

func _on_take_damage(dmg_chunk: Dictionary) -> void:
	# elemental damage is increased
	if dmg_chunk[&'damage'] >= 0:
		var mod := 0.0
		var percent := dmg_chunk.get(&'element_percent', 0.0) as float
		
		if dmg_chunk.get(&'element', Attack.Element.NONE) & element_weaknesses:
			mod = 1.0 + element_mod * level
			
			dmg_chunk[&'element_mod'] += (1.0 - percent) + (percent * mod)

func _on_receive_status(params: Dictionary) -> void:
	# attempt to add some stacks
	var odds = stacks_base + stacks_increase * level
	
	if randf() > odds:
		return
	
	# add some stacks
	params[&'stacks'] = max(params[&'stacks'] + randi_range(1, level), 0)
