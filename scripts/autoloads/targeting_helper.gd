extends Node

# --- Functions --- #

#region GetEntity
func get_entities(group_name: StringName = &'entity') -> Array[Node]:
	return get_tree().get_nodes_in_group(group_name)

func get_alive_entities(group_name: StringName = &'entity') -> Array[Entity]:
	var entities = get_entities(group_name)
	var ret: Array[Entity]
	
	for entity in entities:
		if entity.alive:
			ret.append(entity as Entity)
	
	return ret

func get_entity_by_index(group_name: String = &'entity', index: int = 0) -> Entity:
	var entities = get_alive_entities(group_name)
	
	for entity in entities:
		if entity.spawn_index == index:
			return entity
	
	return null

func get_random_entity(group_name: StringName = &'entity') -> Entity:
	var entites = get_alive_entities(group_name)
	return entites[randi_range(0, len(entites) - 1)] as Entity

func get_neighbors(index: int, group_name: StringName) -> Array[Entity]:
	var entities = get_alive_entities(group_name)
	var ret: Array[Entity]
	
	for entity in entities:
		if entity.spawn_index == index - 1:
			ret.append(entity)
		elif entity.spawn_index == index + 1:
			ret.append(entity)
	
	return ret
	
#endregion

func disable_highlights() -> void:
	var entities = get_entities()
	
	for entity in entities:
		entity.set_targetable(false)
