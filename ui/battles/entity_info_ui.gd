class_name EntityInfoUi
extends Control

# --- Variables --- #

# --- References --- #

# basic info
@onready var name_label := %'name_label' as RichTextLabel
@onready var level_label := %'level_label' as RichTextLabel
@onready var description_label := %'description_label' as RichTextLabel

# stats
@onready var hp_label := %'hp_label' as RichTextLabel
@onready var p_attack_label := %'p_attack_label' as RichTextLabel
@onready var m_attack_label := %'m_attack_label' as RichTextLabel
@onready var p_defense_label := %'p_defense_label' as RichTextLabel
@onready var m_defense_label := %'m_defense_label' as RichTextLabel
@onready var accuracy_label := %'accuracy_label' as RichTextLabel
@onready var evasion_label := %'evasion_label' as RichTextLabel

# elements
@onready var fire_label := %'fire_label' as RichTextLabel
@onready var electric_label := %'electric_label' as RichTextLabel
@onready var nature_label := %'nature_label' as RichTextLabel
@onready var water_label := %'water_label' as RichTextLabel
@onready var ice_label := %'ice_label' as RichTextLabel
@onready var flying_label := %'flying_label' as RichTextLabel
@onready var earth_label := %'earth_label' as RichTextLabel
@onready var light_label := %'light_label' as RichTextLabel
@onready var dark_label := %'dark_label' as RichTextLabel

# --- Functions --- #
func _ready() -> void:
	modulate.a = 1.0
	hide()

func show_entity(entity: Entity) -> void:
	if not entity:
		hide()
		return
	
	# basic info
	name_label.text = entity.entity_name
	level_label.text = "Level " + str(entity.level)
	description_label.text = entity.description
	
	# stats
	hp_label.text = str(round(entity.stats.get_max_hp()))
	p_attack_label.text = str(round(entity.stats.get_attack(false)))
	m_attack_label.text = str(round(entity.stats.get_attack(true)))
	p_defense_label.text = str(round(entity.stats.get_defense(false)))
	m_defense_label.text = str(round(entity.stats.get_defense(true)))
	accuracy_label.text = str(round(entity.stats.get_accuracy()))
	evasion_label.text = str(round(entity.stats.get_evasion()))
	
	# resistances
	fire_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.FIRE))
	fire_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.FIRE))
	
	electric_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.ELECTRIC))
	electric_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.ELECTRIC))

	nature_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.NATURE))
	nature_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.NATURE))

	water_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.WATER))
	water_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.WATER))

	ice_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.ICE))
	ice_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.ICE))

	flying_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.FLYING))
	flying_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.FLYING))

	earth_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.EARTH))
	earth_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.EARTH))

	light_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.LIGHT))
	light_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.LIGHT))

	dark_label.text = get_resistance_text(entity.stats.get_resistance(Attack.Element.DARK))
	dark_label.theme_type_variation = get_resistance_variation(entity.stats.get_resistance(Attack.Element.DARK))
	
	# show
	show()

func get_resistance_text(value: float) -> String:
	return "[center] " + str(round(abs(value) * 100))

func get_resistance_variation(value: float) -> StringName:
	if value < 0.0:
		return &'ElementWeak'
	elif value > 1.0:
		return &'ElementHeal'
	elif value > 0.0:
		return &'ElementResist'
	else:
		return &'ElementNone'

func hide_info() -> void:
	hide()
