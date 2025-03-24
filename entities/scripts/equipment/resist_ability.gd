class_name ResistAbility
extends EquipmentAbility

# --- Variables --- #
@export var resists: String
@export var element_mod := 0.10
@export var stacks_base := 0.25
@export var stacks_increase := 0.25

var element_resists: int
var status_resists: int

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
				element_resists |= Attack.Element.NONE as Attack.Element
			'fire':
				element_resists |= Attack.Element.FIRE as Attack.Element
			'electric':
				element_resists |= Attack.Element.ELECTRIC as Attack.Element
			'nature':
				element_resists |= Attack.Element.NATURE as Attack.Element
			'water':
				element_resists |= Attack.Element.WATER as Attack.Element
			'ice':
				element_resists |= Attack.Element.ICE as Attack.Element
			'flying':
				element_resists |= Attack.Element.FLYING as Attack.Element
			'earth':
				element_resists |= Attack.Element.EARTH as Attack.Element
			'light':
				element_resists |= Attack.Element.LIGHT as Attack.Element
			'dark':
				element_resists |= Attack.Element.DARK as Attack.Element
			'harass':
				status_resists |= Globals.StatusType.HARASS as Globals.StatusType
			'hinder':
				status_resists |= Globals.StatusType.HINDER as Globals.StatusType
			'life':
				status_resists |= Globals.StatusType.LIFE as Globals.StatusType
			'death':
				status_resists |= Globals.StatusType.DEATH as Globals.StatusType
			'body':
				status_resists |= Globals.StatusType.BODY as Globals.StatusType
			'environment':
				status_resists |= Globals.StatusType.ENVIRONMENT as Globals.StatusType

func remove_signals() -> void:
	entity.took_damage.disconnect(_on_take_damage)
	entity.received_status.disconnect(_on_receive_status)

func _on_take_damage(dmg_chunk: Dictionary) -> void:
	# elemental damage is resisted
	if dmg_chunk[&'damage'] >= 0:
		if dmg_chunk.get(&'element', Attack.Element.NONE) & element_resists:
			dmg_chunk[&'element_mod'] += element_mod * level

func _on_receive_status(params: Dictionary) -> void:
	# attempt to remove some stacks
	if params.get(&'status_type', Globals.StatusType.EMPTY) & status_resists:
		params[&'stacks_odds'] -= stacks_base + stacks_increase * level
