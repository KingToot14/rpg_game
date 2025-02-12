class_name HpBar
extends Control

# --- Variables --- #
var entity: Entity

@export var cover_rect: Control
var cover_size: float

@export var hp_label: RichTextLabel
@export var special_label: RichTextLabel
@export var special_color := Color.WHITE
@export var spacing_color := Color.WHITE

# --- Functions --- #
func _ready() -> void:
	cover_size = cover_rect.size.x

func set_entity(e: Entity) -> void:
	entity = e
	
	if entity:
		entity.hp.lost_health.connect(update_health)
	
	update_health()

func update_health(_dmg_chunk: DamageChunk = null) -> void:
	if not (entity and entity.hp.alive):
		hide()
		return
	
	show()
	
	cover_rect.custom_minimum_size.x = cover_size * clamp(entity.hp.get_hp_percent(), 0.0, 1.0)
	hp_label.text = str(entity.hp.curr_hp) + "/" + str(entity.stats.get_max_hp())
	
	if entity.special:
		special_label.clear()
		special_label.append_text("[right]")
		
		# spacer
		special_label.push_color(spacing_color)
		special_label.add_text("|")
		special_label.pop()
		
		# special charge
		special_label.push_color(special_color)
		special_label.add_text(str(floor(entity.special.curr_special)) + "%")
		special_label.pop()
