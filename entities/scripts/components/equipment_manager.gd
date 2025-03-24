class_name EquipmentManager
extends Node

# --- Variables --- #
var parent: Entity

var weapon: Equipment
var primary: OutfitEquipment
var secondary: OutfitEquipment

var trinket1: Equipment
var trinket2: Equipment
var trinket3: Equipment

@export var role: PlayerDataChunk.PlayerRole

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity
	
	var chunk := DataManager.players[parent.spawn_index] as PlayerDataChunk
	
	# load equipment
	if role == PlayerDataChunk.PlayerRole.MELEE:
		# disconnect signals if required
		if weapon:
			weapon.remove_signals()
			primary.remove_signals()
			secondary.remove_signals()
		
		# equipment
		weapon = chunk.weapon as MeleeWeaponEquipment
		primary = chunk.outfit_primary as OutfitEquipment
		secondary = chunk.outfit_secondary as OutfitEquipment
		
		weapon.setup_battle(entity)
		primary.setup_battle(entity)
		secondary.setup_battle(entity)
		
		%'sword'.texture = weapon.sword_sprite
		%'shield'.texture = weapon.shield_sprite
		
		# outfit
		%'primary'.texture = primary.melee_outfit
		%'secondary'.texture = secondary.melee_outfit
		
		# trinkets
		trinket1 = chunk.trinket1 as Equipment
		trinket2 = chunk.trinket1 as Equipment
		trinket3 = chunk.trinket1 as Equipment
		
		if trinket1:
			trinket1.setup_battle(entity)
		if trinket2:
			trinket2.setup_battle(entity)
		if trinket3:
			trinket3.setup_battle(entity)
		
	elif role == PlayerDataChunk.PlayerRole.MONK:
		pass
	elif role == PlayerDataChunk.PlayerRole.RANGED:
		pass
	elif role == PlayerDataChunk.PlayerRole.MAGIC:
		pass

func reload() -> void:
	setup(parent)
