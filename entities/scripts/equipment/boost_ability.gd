class_name BoostAbility
extends EquipmentAbility

# --- Variables --- #
@export var boosts: String

var element_boosts: Attack.Element = 0 as Attack.Element
var status_boosts: Globals.StatusType = 0 as Globals.StatusType
var healing_boost := false

# --- Constants --- #
const ELEMENT_MOD := 0.25
const HEALING_MOD := 0.20

const STACKS_BASE := 0.25
const STACKS_INC := 0.25

# --- Functions --- #
@warning_ignore("int_as_enum_without_cast")
func setup(new_entity: Entity, new_level: int) -> void:
	super(new_entity, new_level)
	
	# connect signals
	entity.deal_damage.connect(_on_deal_damage)
	entity.gave_status.connect(_on_gave_status)
	
	# parse boosts
	for boost in boosts.split(","):
		match boost:
			'none':
				element_boosts &= Attack.Element.NONE as Attack.Element
			'fire':
				element_boosts &= Attack.Element.FIRE as Attack.Element
			'electric':
				element_boosts &= Attack.Element.ELECTRIC as Attack.Element
			'nature':
				element_boosts &= Attack.Element.NATURE as Attack.Element
			'water':
				element_boosts &= Attack.Element.WATER as Attack.Element
			'ice':
				element_boosts &= Attack.Element.ICE as Attack.Element
			'flying':
				element_boosts &= Attack.Element.FLYING as Attack.Element
			'earth':
				element_boosts &= Attack.Element.EARTH as Attack.Element
			'light':
				element_boosts &= Attack.Element.LIGHT as Attack.Element
			'dark':
				element_boosts &= Attack.Element.DARK as Attack.Element
			'harass':
				status_boosts &= Globals.StatusType.HARASS as Globals.StatusType
			'hinder':
				status_boosts &= Globals.StatusType.HINDER as Globals.StatusType
			'life':
				status_boosts &= Globals.StatusType.LIFE as Globals.StatusType
			'death':
				status_boosts &= Globals.StatusType.DEATH as Globals.StatusType
			'body':
				status_boosts &= Globals.StatusType.BODY as Globals.StatusType
			'environment':
				status_boosts &= Globals.StatusType.ENVIRONMENT as Globals.StatusType
			'heal':
				healing_boost = true

func _on_deal_damage(dmg_chunk: Dictionary) -> void:
	# elemental damage is boosted
	if dmg_chunk[&'damage'] > 0:
		var mod := 0.0
		var percent := dmg_chunk.get(&'element_percent', 0.0) as float

		if dmg_chunk.get(&'element', Attack.Element.NONE) & element_boosts:
			mod = 1.0 + ELEMENT_MOD * level

		dmg_chunk[&'damage'] *= (1.0 - percent) + (percent * mod)
	elif healing_boost:
	# healing is boosted
		dmg_chunk[&'damage'] *= 1.0 + HEALING_MOD * level

func _on_gave_status(params: Dictionary) -> void:
	# attempt to give more stacks
	var odds = STACKS_BASE + STACKS_INC * level
	
	if randf() > odds:
		return
	
	# give more stacks
	params[&'stacks'] += randi_range(1, level)
