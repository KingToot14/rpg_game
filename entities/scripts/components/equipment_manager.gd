class_name EquipmentManager
extends Node

# --- Variables --- #
var parent: Entity

@export var role: PlayerDataChunk.PlayerRole

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity
	
	var chunk := DataManager.players[parent.spawn_index] as PlayerDataChunk
	
	# load equipment
	if role == PlayerDataChunk.PlayerRole.MELEE:
		# weapon
		var weapon = chunk.weapon as MeleeWeaponEquipment
		%'sword'.texture = weapon.sword_sprite
		%'shield'.texture = weapon.shield_sprite
		
		weapon.setup_battle(entity)
		
		# outfit
		
		# hat
		
	elif role == PlayerDataChunk.PlayerRole.MONK:
		pass
	elif role == PlayerDataChunk.PlayerRole.RANGED:
		pass
	elif role == PlayerDataChunk.PlayerRole.MAGIC:
		pass
