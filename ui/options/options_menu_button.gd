class_name OptionsMenuButton
extends BaseButton

# --- Signals --- #
signal item_set(item: StringName)

# --- Variables --- #
@export var starting_item: int = 0

var curr_item: StringName
@export var curr_item_label: RichTextLabel

@export var menu_panel: Control
@export var item_parent: Control

# --- Functions --- #
func _ready() -> void:
	pressed.connect(toggle_menu)
	
	var items = item_parent.get_children()
	
	for item in items:
		item.pressed.connect(set_item.bind(item))
	
	set_item(items[starting_item])

func toggle_menu() -> void:
	menu_panel.visible = not menu_panel.visible

func set_item(item: Control) -> void:
	curr_item = item.name
	curr_item_label.text = item.get_node("label").text
	
	item_set.emit(curr_item)
	
	menu_panel.visible = false
