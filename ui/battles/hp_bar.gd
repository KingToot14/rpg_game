class_name HpBar
extends Control

# --- Variables --- #
var entity: Entity

@export var cover_rect: ColorRect
var cover_size: float

@export var hp_label: Label
@export var special_label: Label

# --- Functions --- #
func _ready() -> void:
	cover_size = cover_rect.size.x

func set_entity(e: Entity) -> void:
	entity = e
	
	if entity:
		entity.hp.lost_health.connect(update_health)
	
	update_health()

func update_health(_dmg: int = 0) -> void:
	if not (entity and entity.hp.alive):
		hide()
		return
	
	show()
	
	cover_rect.size.x = cover_size * clamp(entity.hp.get_hp_percent(), 0.0, 1.0)
	hp_label.text = str(entity.hp.curr_hp) + "/" + str(entity.stats.get_max_hp())
	
	if entity.special:
		special_label.text = str(floor(entity.special.curr_special)) + "%"
