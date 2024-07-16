class_name StatusEffectInfo
extends Resource

# --- Variables --- #
@export var key: StringName
@export var names: Array[String] = []
@export_multiline var descriptions: Array[String] = []
@export var small_icon: Texture2D
@export var large_icons: Array[Texture2D] = []

@export var effect_class: GDScript

# --- Functions --- #
func get_effect_name(stage := 1) -> String:
	return names[stage - 1]

func get_description(stage := 1) -> String:
	return descriptions[stage - 1]

func get_small_icon() -> Texture2D:
	return small_icon

func get_large_icon(stage := 1) -> Texture2D:
	return large_icons[stage - 1]
