class_name HpBar
extends Control

# --- Variables --- #
@export var cover_rect: ColorRect
var cover_size: float

@export var hp_label: Label
@export var special_label: Label

# --- Functions --- #
func _ready() -> void:
	cover_size = cover_rect.size.x

func update_health(_dmg: float, entity: Entity) -> void:
	if not entity:
		visible = false
		return
	else:
		visible = true
	
	cover_rect.size.x = cover_size * clamp(entity.get_hp_percent(), 0, 1)
	hp_label.text = str(entity.hp) + "/" + str(entity.max_hp)

func update_special(entity: Entity) -> void:
	special_label.text = str(floor(entity.special_charge)) + "%"
