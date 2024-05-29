class_name Interactable
extends Area2D

# --- Signals --- #
signal interacted_with()

# --- Variables --- #
@export var box_offset: float = 20.0
@export var icon: Texture2D

var in_range: bool = false
var interactable: bool = true

# --- References --- #
@onready var box_rect := $"interaction_box" as TextureRect
@onready var icon_rect := $"interaction_box/icon" as TextureRect

# --- Functions --- #
func _ready() -> void:
	# Setup signals
	body_entered.connect(object_moved.bind(true))
	body_exited.connect(object_moved.bind(false))
	
	# Setup interaction box
	box_rect.position.y = -box_rect.size.y / 2.0 - box_offset
	icon_rect.texture = icon
	
	box_rect.visible = false

func _input(event: InputEvent) -> void:
	if not event.is_action_pressed('overworld_interact') or not in_range:
		return
	
	interacted_with.emit()

func object_moved(_body: Node2D, entered: bool) -> void:
	in_range = entered and interactable
	
	# Show interaction icon
	set_box_visibility(in_range)

func set_box_visibility(value: bool) -> void:
	box_rect.visible = value
	
