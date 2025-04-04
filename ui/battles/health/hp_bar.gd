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
		entity.turn_ended.connect(func(_p):
			await get_tree().process_frame
			update_health()
		)
		entity.hp.lost_health.connect(update_health)
		entity.hp.heal_health.connect(update_health)
	
	update_health()

func update_health(_dmg_chunk: Dictionary = {}) -> void:
	if not (entity and entity.hp.alive):
		hide()
		return
	
	show()
	
	cover_rect.custom_minimum_size.x = cover_size * clamp(entity.hp.get_hp_percent(), 0.0, 1.0)
	hp_label.text = "%d/%d" % [entity.hp.curr_hp, entity.stats.get_max_hp()]
	
	if entity.special:
		if entity.special.curr_special >= 100:
			$'special_fill'.show()
		else:
			$'special_fill'.hide()
			special_label.clear()
			special_label.append_text("[right]")
			special_label.push_color(special_color)
			special_label.add_text("%d%%" % entity.special.curr_special)
			special_label.pop_all()
