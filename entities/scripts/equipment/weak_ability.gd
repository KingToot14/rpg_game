class_name WeakAbility
extends EquipmentAbility

# --- Variables --- #
@export var resists: String
@export var element_mod := 0.10
@export var stacks_base := 0.25

var element_weaknesses: int
var status_weaknesses: int

# --- Functions --- #
func setup_signals() -> void:
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

func remove_signals() -> void:
	entity.took_damage.disconnect(_on_take_damage)
	entity.received_status.disconnect(_on_receive_status)

func _on_take_damage(dmg_chunk: Dictionary) -> void:
	# elemental damage is increased
	if dmg_chunk[&'damage'] >= 0:		
		if dmg_chunk.get(&'element', Attack.Element.NONE) & element_weaknesses:
			dmg_chunk[&'element_mod'] = dmg_chunk.get(&'element_mod', 0) + element_mod

func _on_receive_status(params: Dictionary) -> void:
	# attempt to add some stacks
	if params.get(&'status_type', Globals.StatusType.EMPTY) & status_weaknesses:
		params[&'stacks_odds'] = params.get(&'stacks_odds', 0) + stacks_base
