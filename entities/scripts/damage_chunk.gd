class_name DamageChunk
extends Resource

# --- Variables --- #
var damage := 0.0
var element: Attack.Element
var element_percent := 0.0

# --- Functions --- #
func _init(init_dmg := 0.0, init_element := Attack.Element.NONE, init_percent := 0.0) -> void:
	damage = init_dmg
	element = init_element
	element_percent = init_percent
