class_name AppearanceManager
extends Node

# --- Variables --- #
@export var entity_material: ShaderMaterial

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity
	
	load_appearance()

func load_appearance() -> void:
	var data := DataManager.players[parent.spawn_index] as PlayerDataChunk
	
	AsyncLoader.new(data.get_appearance_path(), set_appearance)

func set_body() -> void:
	pass

func set_appearance(appearance: PlayerAppearance) -> void:
	entity_material.set_shader_parameter('outline_color', appearance.outline_color)
	entity_material.set_shader_parameter('normal_color', appearance.normal_color)
	entity_material.set_shader_parameter('shadow_color', appearance.shadow_color)
