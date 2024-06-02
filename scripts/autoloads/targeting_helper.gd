extends Node

# --- Functions --- #
func get_entities(group_name: StringName) -> Array[Node]:
	return get_tree().get_nodes_in_group(group_name)

func get_random_entity(group_name: StringName) -> Entity:
	var entites = get_entities(group_name)
	return entites[randi_range(0, len(entites) - 1)] as Entity
