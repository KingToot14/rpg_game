class_name ActionMenuItem
extends BaseButton

# --- Variables --- #
@export var item: Resource

# --- References --- #
var icon_rect: TextureRect
@onready var backing := $"backing" as Control

# --- Functions --- #
func _ready() -> void:
	icon_rect = $"icon" as TextureRect
	
	pressed.connect(set_item)
	
	if item:
		set_menu_item(item)

func show_outline() -> void:
	backing.visible = true

func hide_outline() -> void:
	backing.visible = false

func set_menu_item(new_item: Resource) -> void:
	item = new_item
	
	visible = not not item
	
	if item and "icon" in item:
		icon_rect.texture = item.icon

func set_item() -> void:
	Globals.set_item(item)
	release_focus()
