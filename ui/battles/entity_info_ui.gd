class_name EntityInfoUi
extends Control

# --- Variables --- #

# --- References --- #
@onready var name_label := %'name_label' as RichTextLabel
@onready var level_label := %'level_label' as RichTextLabel
@onready var description_label := %'description_label' as RichTextLabel

# --- Functions --- #
func _ready() -> void:
	modulate.a = 0.0

func show_entity(entity: Entity) -> void:
	if not entity:
		modulate.a = 0.0
		return
	
	name_label.text = entity.entity_name
	level_label.text = "Level " + str(entity.level)
	description_label.text = entity.description
	
	modulate.a = 1.0

func hide_info() -> void:
	modulate.a = 0.0
